package PneumoDB::Controller::UpdateComments;
use Moose;
use namespace::autoclean;
use JSON;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::UpdateComments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
# Create sql in-string
sub createSqlString {
  my $row = shift;
  my $strArr = ();
  my $conditionStrArr = ();

  my $qstring;
  my $final_query = "UPDATE pneumodb_results SET";

  for my $k (keys %$row) {
    if(defined $row->{$k}) {
      if($k ne "pss_lane_id" && $k ne "pss_sanger_id") {
        if ($row->{$k} eq "") {
          push(@$strArr, qq{ $k = NULL });
        }
        else {
          push(@$strArr, qq{ $k = "$row->{$k}" });
        }
      }
      elsif ($k eq "pss_lane_id" && $row->{$k} ne "") {
        push(@$conditionStrArr, qq{ prs_lane_id = "$row->{$k}" });
      }
      elsif ($k eq "pss_sanger_id" && $row->{$k} ne "") {
        push(@$conditionStrArr, qq{ prs_sanger_id = "$row->{$k}" });
      }
    }
  }

  $final_query .= join(',', @$strArr);
  $final_query .= ' WHERE ' . join(' AND ', @$conditionStrArr) . ' ';

  return $final_query;
}

# Update comments in the GPS database
sub updateComments : Path('/pneumodb/update/comments') {
  my ( $self, $c, @args ) = @_;

  my $schema = $c->model('PneumoDB::PneumodbResult');
  my $postData = from_json $c->request->params->{data};
  my $rs;
  my $txn;
  my $res = {};
  # Logging
  my $log_str = '';
  $log_str .= (defined $c->user->pnu_institution)?$c->user->get('pnu_name'):"GUEST-$c->request->address";
  $log_str .= '-UpdateComments-'.to_json($postData) if(scalar @$postData > 0);
  $c->log->warn($log_str);
  my $q;
  my $sth;
  my $now;

  foreach my $row (@{$postData}) {
    try {

      # Create quesry in-string to inject into the mysql query string
      my $qstring = createSqlString($row);

      # There can be a sample without a lane id. So if its not found in below command, we should
      # get them using sanger id.
      if(defined $row->{pss_lane_id} && defined $row->{pss_sanger_id}) {
        $rs = $schema->search({'prs_lane_id' => $row->{pss_lane_id}});
      }
      elsif(defined $row->{pss_sanger_id}) {
        $rs = $schema->search({ 'prs_sanger_id' => $row->{pss_sanger_id}});
      }
      else {
        $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Sanger ID or Lane ID missing. Could not update!}};
      }

      if($rs->count) {
        $c->config->{pneumodb_dbh}->do($qstring) or die "Could not save! Error while executing query - $!";
      }
      else {
        $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Sanger ID or Lane ID not found in the database. Could not update!}};
      }
    }
    catch {
      $c->config->{pneumodb_dbh}->rollback;
      $res = {'err' => 'Error occured while saving', 'errMsg' => qq{$_}};
      $c->res->body(to_json($res));

    }
  }
  # Return the number of rows updated
  if(!defined $res->{'err'}) {
    $c->config->{pneumodb_dbh}->commit;
    $res->{'success'} = @{$postData};
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
