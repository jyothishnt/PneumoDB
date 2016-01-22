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
  my $type_text;
  if($type == -1) {
    $type_text = "Pending";
  }
  elsif($type == 0) {
    $type_text = "Fail";
  }
  elsif($type == 1) {
    $type_text = "Pass";
  }
  elsif($type == 2) {
    $type_text = "Pass Plus";
  }
  elsif($type == 3) {
    $type_text = "Non Pneumo";
  }
  else {
    $type_text = "Unknown";
  }

  $q1 = qq{UPDATE pneumodb_results SET prs_pneumo_qc = ?, prs_updated_on = now() WHERE prs_sanger_id = ? AND prs_lane_id = ?};
  $sth1 = $c->config->{pneumodb_dbh}->prepare($q1) or die "Could not save! Error while preparing query - $!";
  $q2 = qq{UPDATE pneumodb_results SET prs_pneumo_qc = ?, prs_updated_on = now() WHERE prs_sanger_id = ? AND prs_lane_id IS NULL};
  $sth2 = $c->config->{pneumodb_dbh}->prepare($q2) or die "Could not save! Error while preparing query - $!";
  my $success = {};
  foreach my $row (@{$postData}) {
    try {
      # If both sanger and lane ids are present in the post data
      if(defined $row->{pss_lane_id} && defined $row->{pss_sanger_id}) {
        $rs = $schema->search({ 'prs_lane_id' => $row->{pss_lane_id} });
        if($rs->count) {
          $sth1->execute($type_text, $row->{pss_sanger_id}, $row->{pss_lane_id}) or die "Could not save! Error while executing query - $!";
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
          $sth2->execute($type_text, $row->{pss_sanger_id}) or die "Could not save! Error while executing query - $!";
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
    $success->{rows} = $#$postData + 1;
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
