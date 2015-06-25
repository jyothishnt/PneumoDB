package PneumoDB::Controller::UpdateDecision;
use Moose;
use namespace::autoclean;
use JSON;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

PneumoDB::Controller::UpdateDecision - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


# Update decision 0/1/-1 representing exclude/include/new entries respectively
sub updateDecision : Path('/pneumodb/update/decision') {
  my ( $self, $c, @args ) = @_;
  my $type = (defined $c->request->param('type'))?$c->request->param('type'):1;
  my $schema = $c->model('PneumoDB::PneumodbResult');
  my $postData = from_json $c->request->params->{data};

  my $rs;
  my $txn;
  my $res = {};
  # Logging
  my $log_str = '';
  $log_str .= (defined $c->user->pnu_institution)?$c->user->get('pnu_name'):"GUEST-$c->request->address";
  $log_str .= "-UpdateDecision-$type-".to_json($postData) if(scalar @$postData > 0);
  $c->log->warn($log_str);
  my ($q1, $q2);
  my ($sth1, $sth2);
  my $now;
  $q1 = qq{UPDATE pneumodb_results SET prs_decision = ?, prs_updated_on = now() WHERE prs_sanger_id = ? AND prs_lane_id = ?};
  $sth1 = $c->config->{pneumodb_dbh}->prepare($q1) or die "Could not save! Error while preparing query - $!";
  $q2 = qq{UPDATE pneumodb_results SET prs_decision = ?, prs_updated_on = now() WHERE prs_sanger_id = ? AND prs_lane_id IS NULL};
  $sth2 = $c->config->{pneumodb_dbh}->prepare($q2) or die "Could not save! Error while preparing query - $!";
  my $success = {};
  foreach my $row (@{$postData}) {
    try {
      # If both sanger and lane ids are present in the post data
      if(defined $row->{pss_lane_id} && defined $row->{pss_sanger_id}) {
        $rs = $schema->search({ 'prs_lane_id' => $row->{pss_lane_id} });
        if($rs->count) {
          $sth1->execute($type, $row->{pss_sanger_id}, $row->{pss_lane_id}) or die "Could not save! Error while executing query - $!";
        }
        else {
          $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Lane ID not found in the database}};
          $c->config->{pneumodb_dbh}->rollback;
          $c->res->body(to_json($res));
        }
        # For counting the total no. of rows updated. This include all the duplicate rows for each public name in the postData list
      }
      # If only sanger id is present in the post data
      elsif(defined $row->{pss_sanger_id}) {
        $rs = $schema->search({ 'prs_sanger_id' => $row->{pss_sanger_id}});
        if($rs->count) {
          $sth2->execute($type, $row->{pss_sanger_id}) or die "Could not save! Error while executing query - $!";
          # For counting the total no. of rows updated. This include all the duplicate rows for each public name in the postData list
        }
        else {
          $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Sanger ID not found in the database}};
          $c->config->{pneumodb_dbh}->rollback;
          $c->res->body(to_json($res));
        }
      }
      else {
        $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Sanger ID and Lane ID not found in the database}};
        $c->config->{pneumodb_dbh}->rollback;
        $c->res->body(to_json($res));
      }

      # Update sample_outcome based on the below conditions
=head
        For public name X. Is there A SINGLE record (only one) with public name X that has decision 1, outcome js "Sample completed".
        if not
        For public name X. Is there more than one record with public name X that has decision 1, outcome is "Sample completed".
        if not
        Is there any record with public name X that has decision -1, outcome is "Sample in progress"
        else
        outcome is "Sample failed".
=cut

      # Get all sanger ids for the public name
      if(defined $row->{pss_public_name} && $row->{pss_public_name} ne "") {
        my $q = qq{SELECT pss_sanger_id FROM pneumodb_sequence_scape where pss_public_name = ?};
        my $sth = $c->config->{pneumodb_dbh}->prepare($q) or die "Could not save! Error while preparing query - $!";
        $sth->execute($row->{pss_public_name}) or die "Could not save! Error while executing query - $!";

        if($sth->rows > 0) {
          my $res_arr = $sth->fetchall_arrayref();
          # Create the string of sanger ids for IN making query
          my $t_arr = ();
          foreach my $row (@$res_arr) {
            (ref $row eq "ARRAY")? push @$t_arr, $row->[0]: push @$t_arr, $row;
          }

          my $sample_outcome;
          # Creating a string for mysql string search with all the sanger ids for the given public name
          my $t_sam_str = '"'.join('","',@$t_arr).'"';
          $q = qq{SELECT prs_decision FROM pneumodb_results where prs_sanger_id IN ($t_sam_str)};
          $sth = $c->config->{pneumodb_dbh}->prepare($q) or die "Could not save! Error while preparing query - $!";
          $sth->execute() or die "Could not save! Error while preparing query - $!";
          if($sth->rows() > 0) {
            while(my $arr = $sth->fetchrow_arrayref()) {
              my $dec = $arr->[0];
              # If there is atleast one sample with decision 1, then sample is completed
              if($dec == 1 || $dec == 2) {
                $sample_outcome = 'Sample completed';
                last;
              }
              elsif($dec == -1) {
                # If there is atleast one sample with decision -1, then sample is in progress
                $sample_outcome = 'Sample in progress';
                last;
              }
              elsif($dec == 0) {
                # If decision(in db)  = 0 and current decision = 1, then sample completed. Else failed
                ($type == 1)?$sample_outcome = 'Sample Completed' : $sample_outcome = 'Sample failed';
              }
            }
          }
          else {
            $res = {'err' => 'Error', 'errMsg' => "$row->{pss_public_name} not found in GPS Results table"};
            $c->config->{pneumodb_dbh}->rollback;
            $c->res->body(to_json($res));
            return;
          }
          # For counting the total no. of rows updated. This include all the duplicate rows for each public name in the postData list
          $success->{rows} += ($sth->rows())?$sth->rows():0;
          $success->{final_sample_outcome} = $sample_outcome;

          # Update sample outcome
          $q = qq{UPDATE pneumodb_results SET prs_sample_outcome = "$sample_outcome", prs_updated_on = now() where prs_sanger_id IN ($t_sam_str)};
          $sth = $c->config->{pneumodb_dbh}->do($q);
        }
        else {
          $res = {'err' => 'Error', 'errMsg' => "Sanger id not found for $row->{pss_public_name}"};
          $c->config->{pneumodb_dbh}->rollback;
          $c->res->body(to_json($res));
          return;
        }
      }
      else {
        $res = {'err' => 'Error', 'errMsg' => "Public name not found for $row->{pss_sanger_id}"};
        $c->config->{pneumodb_dbh}->rollback;
        $c->res->body(to_json($res));
        return;
      }
    }
    catch {
      $res = {'err' => 'Error occured while saving', 'errMsg' => qq{$_}};
      $c->config->{pneumodb_dbh}->rollback;
      $c->res->body(to_json($res));
      return;
    }
  }
  # Return the number of rows updated
  if(!defined $res->{'err'}) {
    $c->config->{pneumodb_dbh}->commit;
    $res->{'success'} = $success;
  }

  $c->res->body(to_json($res));
}

=encoding utf8

=head1 AUTHOR

Jyothish  N.N.T. Bhai

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
