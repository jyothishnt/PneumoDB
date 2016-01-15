package PneumoDB::Controller::JsonUtilityServices;
use Moose;
use namespace::autoclean;
use JSON;
use WWW::Mechanize;
use Spreadsheet::XLSX;
use Spreadsheet::ParseExcel;
use Text::CSV;
use PneumoDB::Controller::SearchPneumoDB;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

PneumoDB::Controller::JsonUtilityServices - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


# Get json formatted data for PneumoDB project site - googlemap GeoJSON API
# This function takes a column name in pneumodb_metadata column and
# generates a json with its disticnt column values and no. of entries
sub getSampleCount :Path('/json/meta/') {
  my ( $self, $c, @args ) = @_;
  my $map = [];
  if(scalar @args > 0) {
    # Get the column name
    my $colname_search = $args[0];
    # Reconnect to db if connection available
    if(!$c->config->{pneumodb_dbh}->ping) {
      my $attr = {
          mysql_auto_reconnect => $c->config->{mysql_auto_reconnect},
          AutoCommit => $c->config->{AutoCommit}
      };
      $c->log->warn("Re-connected @ getSampleCount_Country() ".$c->config->{dsn});
      my $dbh = DBI->connect($c->config->{dsn},$c->config->{user},$c->config->{password}, $attr);
      $c->config->{pneumodb_dbh} = $dbh;
    }

    my $q = qq {
      SELECT
        m.$colname_search,
        count(m.$colname_search) as $colname_search\_count,
        c.pco_latitude,
        c.pco_longitude
      FROM pneumodb_sequence_scape s, pneumodb_metadata m, pneumodb_results r, pneumodb_coordinates c
      WHERE m.pmd_public_name = s.pss_public_name
      AND c.pco_location = m.pmd_country
      AND s.pss_sanger_id = r.prs_sanger_id
      AND r.prs_lane_id = s.pss_lane_id
      AND r.prs_decision<>0
      AND m.$colname_search IS NOT NULL
      AND m.$colname_search <> ""
      GROUP BY $colname_search;
    };

    my $sth = $c->config->{pneumodb_dbh}->prepare($q);
    $sth->execute;
    # Create a resultset with a groupby clause
    if($sth->rows > 0) {
      my $t_map = {};
      while(my $row = $sth->fetchrow_hashref) {
        # Creating a hash of column value and count
        $t_map = {};
        $t_map->{$row->{'pmd_country'}}->{sample_count} = $row->{pmd_country_count};
        $t_map->{$row->{'pmd_country'}}->{lat} = $row->{pco_latitude};
        $t_map->{$row->{'pmd_country'}}->{lng} = $row->{pco_longitude};
        push @{$map}, $t_map;
      }
      # Send back json
      $c->res->body(to_json($map));
    }
    else {
      # If no column found then show the 404 template
      $c->res->body('Column name not found');
    }
  }
  else {
    # If no arguments then show the 404 template
    $c->res->body('Column name argument missing');
  }
}

sub getCoordinates :Path('/json/coordinates/') {
  my ( $self, $c, @args ) = @_;
  my $map = [];
  if(scalar @args > 0) {
    # Get the column name
    my $location = $args[0];
    # Reconnect to db if connection available
    if(!$c->config->{pneumodb_dbh}->ping) {
      my $attr = {
          mysql_auto_reconnect => $c->config->{mysql_auto_reconnect},
          AutoCommit => $c->config->{AutoCommit}
      };
      $c->log->warn("Re-connected @ getSampleCount_Country() ".$c->config->{dsn});
      my $dbh = DBI->connect($c->config->{dsn},$c->config->{user},$c->config->{password}, $attr);
      $c->config->{pneumodb_dbh} = $dbh;
    }

    my $q = qq {
      SELECT
        pco_location,
        pco_latitude,
        pco_longitude
      FROM
        pneumodb_coordinates
      WHERE
        pco_location = ?
    };

    my $sth = $c->config->{pneumodb_dbh}->prepare($q);
    $sth->execute($location);
    # Create a resultset with a groupby clause
    if($sth->rows > 0) {
      my $t_map = {};
      while(my $row = $sth->fetchrow_hashref) {
        # Creating a hash of column value and count
        $t_map = {};
        $t_map->{$row->{'pco_location'}}->{lat} = $row->{pco_latitude};
        $t_map->{$row->{'pco_location'}}->{lng} = $row->{pco_longitude};
        push @{$map}, $t_map;
      }
      # Send back json
      $c->res->body(to_json($map));
    }
    else {
      # If no column found then show the 404 template
      $c->res->body('Country not found');
    }
  }
  else {
    # If no arguments then show the 404 template
    $c->res->body('Country argument missing');
  }
}

# Get json - column + count (Same as the function getSampleCount() in this package,
# but to make it authorised access, we are removing 'json/' form the url)
# This function takes a column name in pneumodb_metadata column and
# generates a json with its disticnt column values and no. of entries
sub getSampleCountAuthorised :Path('/count/meta/') {
  my ( $self, $c, @args ) = @_;
  my $map = {};
  if(scalar @args > 0) {
    # Get the column name
    my $colname_search = $args[0];
    # Reconnect to db if connection available
    if(!$c->config->{pneumodb_dbh}->ping) {
      my $attr = {
          mysql_auto_reconnect => $c->config->{mysql_auto_reconnect},
          AutoCommit => $c->config->{AutoCommit}
      };
      $c->log->warn("Re-connected @ getSampleCountAuthorised() ".$c->config->{dsn});
      my $dbh = DBI->connect($c->config->{dsn},$c->config->{user},$c->config->{password}, $attr);
      $c->config->{pneumodb_dbh} = $dbh;
    }

    my $prefix = PneumoDB::Controller::SearchPneumoDB::getColumnPrefix($colname_search);

    my $q = qq {
      SELECT
        $prefix.$colname_search,
        count($prefix.$colname_search) as $colname_search\_count
        FROM pneumodb_sequence_scape as SC
        LEFT JOIN pneumodb_sequence_data as S
            ON SC.pss_lane_id = S.psd_lane_id
        LEFT JOIN pneumodb_results as U
            ON (SC.pss_lane_id = U.prs_lane_id AND SC.pss_sanger_id = U.prs_sanger_id)
            OR (SC.pss_lane_id IS NULL AND SC.pss_sanger_id = U.prs_sanger_id)
        LEFT JOIN pneumodb_metadata as M
            ON SC.pss_public_name = M.pmd_public_name
        GROUP BY $prefix.$colname_search
    };

    my $sth = $c->config->{pneumodb_dbh}->prepare($q);
    $sth->execute;
    # Create a resultset with a groupby clause
    if($sth->rows > 0) {
      while(my $row = $sth->fetchrow_hashref) {
        # Creating a hash of column value and count
        if(defined $row->{$colname_search}) {
          $map->{$row->{$colname_search}}->{sample_count} = $row->{$colname_search.'_count'};
        }
      }
      # Send back json
      $c->res->body(to_json($map));
    }
    else {
      # If no column found then show the 404 template
      $c->res->body('Column name not found');
    }
  }
  else {
    # If no arguments then show the 404 template
    $c->res->body('Column name argument missing');
  }
}

# Populate search drop down
sub populateSearch :Path('/populate_search/') {
  my ( $self, $c, @args ) = @_;
  if (scalar @args > 0) {
    my $colname_search = ();
    push @$colname_search, $args[0];

    my $search_data = {};
    my $qString = &PneumoDB::Controller::SearchPneumoDB::createQuery($search_data, $colname_search, 'search', $c);
    my $map = {};

    # Get unique list
    $qString =~s/SELECT/SELECT DISTINCT/i;
    my $rs = &PneumoDB::Controller::SearchPneumoDB::getSearchResults($qString, $c);

    if($rs && $rs->{rows}) {
      # Process JSON to create an array of hash
      foreach my $val (@{$rs->{rows}}) {
        # Creating a hash of column value and count
        push @{$map->{$colname_search->[0]}}, $val->{$colname_search->[0]};
      }
      # Send back json
      $c->res->body(to_json($map));
    }
    else {
      # If no column found then show the 404 template
      $c->res->body(to_json({'error' => 'No data found'}));
    }
  }
  else {
    # If no arguments then show the 404 template
    $c->res->body(to_json({'error' => 'Column name argument missing'}));
  }
}

# Get all rows for selected columns
sub getColumnData :Path('/get_column_data/') {
  my ( $self, $c, @args ) = @_;
  my $postData = $c->request->body_data;
  my $colArr = $postData->{select_columns};

  if ($#$colArr >= 0) {
    my $search_data->{search_input} = ($postData->{search_input} ne '')? decode_json($postData->{search_input}) : ();
    my $qString = &PneumoDB::Controller::SearchPneumoDB::createQuery($search_data, $colArr, 'search', $c);
    my $rs = &PneumoDB::Controller::SearchPneumoDB::getSearchResults($qString, $c);
    if($rs) {
      # Send back json
      $c->res->body(to_json($rs));
    }
    else {
      # If no column found then show the 404 template
      $c->res->body(to_json({'error' => 'No data found'}));
    }
  }
  else {
    # If no arguments then show the 404 template
    $c->res->body(to_json({'error' => 'Column name argument missing'}));
  }
}

sub parseXLSX {
  my $fh = shift || die "Parse file not specified";
  my $parsedData = {};
  my $excel = Spreadsheet::XLSX -> new ($fh);

  foreach my $sheet (@{$excel -> {Worksheet}}) {
    $sheet -> {MaxRow} ||= $sheet -> {MinRow};
     foreach my $row ($sheet -> {MinRow} +1 .. $sheet -> {MaxRow}) {
      $sheet -> {MaxCol} ||= $sheet -> {MinCol};
      foreach my $col ($sheet -> {MinCol} + 1 ..  $sheet -> {MaxCol}) {
        my $lane = $sheet->{Cells}[$row][0]->{Val};
        if (defined $lane) {
          my $new_value = $sheet->{Cells}[$row][$col]->{Val};
          push (@{$parsedData->{$lane}}, (defined $new_value) ? $new_value  : "");
        }
      }
    }
  }
  return $parsedData;
}

sub parseXLS {
  my $fh = shift || die "Parse file not specified";
  my $parser   = Spreadsheet::ParseExcel->new();
  my $workbook = $parser->parse($fh);
  my $parsedData = {};
  if ( !defined $workbook ) {
      die $parser->error(), ".\n";
  }

  for my $worksheet ( $workbook->worksheets() ) {
    my ( $row_min, $row_max ) = $worksheet->row_range();
    my ( $col_min, $col_max ) = $worksheet->col_range();

    for my $row ( $row_min+1 .. $row_max ) {
      my $lane = $worksheet->get_cell( $row, 0 )->value();
      for my $col ( $col_min + 1 .. $col_max ) {
        my $cell = $worksheet->get_cell( $row, $col );
        my $value = '';
        if($cell) {
          $value = $cell->value();
        }
        if($lane) {
          push (@{$parsedData->{$lane}}, (defined $value)? $value : '');
        }
      }
    }
  }

  return $parsedData;
}

sub parseCSV {
  my $fh = shift || die "Parse file not specified";
  my $parsedData = {};
  my @arr;

  my @rows;
  my $csv = Text::CSV->new ( { binary => 1 } )  # should set binary attribute.
                 or die "Cannot use CSV: ".Text::CSV->error_diag ();
  my $col_header_flag = 1;
  while ( my $row = $csv->getline( $fh )) {
    if (!$col_header_flag) {
      foreach my $val (@$row[1 .. $#$row]) {
        if (defined $row->[0]) {
          push @{$parsedData->{$row->[0]}}, (defined $val)? $val : '';
        }
      }
    }
    $col_header_flag = 0;
  }
  $csv->eof or $csv->error_diag();
  close $fh;
  $csv->eol ("\r\n");

  return $parsedData;
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
