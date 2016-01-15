package PneumoDB::Controller::SiteLoad;
use Moose;
use namespace::autoclean;
use JSON;
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::SiteLoad - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


# Function that gets called for loading the initial page.
# This sends db columns as a 2D array to the template
sub pneumoDataDisplayMain :Path('/pneumodb/data/') :Args(0) {
  my ( $self, $c ) = @_;
  my @col_arr = ();
  my $col = ();

  # Get all the columns from the database to populate HTML dropdown in the search form
  # Pushing columns from sequence scape table
  my $schema = $c->model('PneumoDB::PneumodbSequenceScape');
  my @columns = $schema->result_source->columns;
  push(@col_arr, @columns);
  push(@{$col}, [@col_arr]);

  # Pushing columns from PneumoDB results table
  $schema = $c->model('PneumoDB::PneumodbResult');
  @columns = $schema->result_source->columns;
  splice (@columns,0,2);
  push(@col_arr, @columns);
  push(@{$col}, [@columns]);

  # Pushing columns from PneumoDB results table
  $schema = $c->model('PneumoDB::PneumodbResultsMlst');
  @columns = $schema->result_source->columns;
  splice (@columns,0,1);
  push(@col_arr, @columns);
  push(@{$col}, [@columns]);

  # Pushing columns from PneumoDB results table
  $schema = $c->model('PneumoDB::PneumodbResultsAntibiotic');
  @columns = $schema->result_source->columns;
  splice (@columns,0,1);
  push(@col_arr, @columns);
  push(@{$col}, [@columns]);

  # Pushing columns from sequence data table
  $schema = $c->model('PneumoDB::PneumodbSequenceData');
  @columns = $schema->result_source->columns;
  splice (@columns,0,4);
  splice (@columns,2,1);
  splice (@columns,6,1);
  splice (@columns,9,1);
  push(@col_arr, @columns);
  push(@{$col}, [@columns]);

  # Pushing columns from metadata table
  $schema = $c->model('PneumoDB::PneumodbMetadata');
  @columns = $schema->result_source->columns;
  push(@col_arr, @columns);
  splice (@columns,1,1);
  push(@{$col}, [@columns]);

  # Pushing columns from metadata table
  $schema = $c->model('PneumoDB::PneumodbCoordinates');
  @columns = $schema->result_source->columns;
  push(@col_arr, @columns);
  splice (@columns,0,1);
  push(@{$col}, [@columns]);

  # Pushing columns from metadata table
  $schema = $c->model('PneumoDB::PneumodbStudy');
  @columns = $schema->result_source->columns;
  push(@col_arr, @columns);
  splice (@columns,0,1);
  push(@{$col}, [@columns]);

  #$c->stash->{search_columns} = to_json(\@col_arr);
  $c->stash->{pneumodb_column_2d_array} = to_json($col);
  $c->stash->{username} = 'PneumoDB Search';
  $c->stash->{template} = 'site/grid_display.tt';
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
