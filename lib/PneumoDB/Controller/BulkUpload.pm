package PneumoDB::Controller::BulkUpload;
use Moose;
use namespace::autoclean;
use JSON;
use Spreadsheet::XLSX;
use Spreadsheet::ParseExcel;
use Text::CSV;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

PneumoDB::Controller::FileUploadST - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# Bulk update ST data into pneumodb_results table via file upload
sub bulkUpload :Path('/bulk_upload/') {
  my ( $self, $c, @args ) = @_;
  # Get post data
  my $postData = $c->request->parameters;
  # Logging
  my $upfile = $c->request->upload('st_update_file');
  my $column = $c->request->param('st_update_type');
  my $log_str = '';
  $log_str .= (defined $c->user->pnu_institution)?$c->user->get('pnu_name'):"GUEST-$c->request->address";
  $log_str .= "-BulkUpload-$column-".to_json($postData) if(scalar keys %{$postData} > 0);
  $c->log->warn($log_str);
  my $res = {};
  $res->{rows_updated} = 0;

  if(!$column) {
    $res->{err} = 'Type not specified';
    $c->res->body(to_json($res));
    return;
  }


  my $extension = (split('\.', $upfile->filename))[-1];
  my $parsedData = {};
  if($extension eq "xlsx") {
    $parsedData = PneumoDB::Controller::JsonUtilityServices::parseXLSX($upfile->fh);
  }
  elsif($extension eq "xls") {
    $parsedData = PneumoDB::Controller::JsonUtilityServices::parseXLS($upfile->fh);
  }
  elsif($extension eq "csv") {
    $parsedData = PneumoDB::Controller::JsonUtilityServices::parseCSV($upfile->fh);
  }

  if ($column eq "mlst") {
    $res  = uploadMLST($c, $parsedData);
  }
  elsif ($column eq "antibiotic") {
    $res  = uploadAntibiotic($c, $parsedData);
  }
  else {
    my $q;
    eval {
      foreach my $lane (keys %$parsedData) {
        my $rows_affected;
        try {
          $q = qq {
            UPDATE pneumodb_results SET $column = '$parsedData->{$lane}->[0]', prs_updated_on = now() WHERE prs_lane_id = '$lane'
          };

          $rows_affected = $c->config->{pneumodb_dbh}->do($q) or die $!;
          if($rows_affected == 0  or $rows_affected eq '0E0') {
            push @{$res->{rows_not_updated}}, $lane;
          }
          else {
            $res->{rows_updated}++;
          }
        }
        catch {
          # Updated = 0 due to rollback
          $res->{rows_updated} = 0;
          $c->config->{pneumodb_dbh}->rollback();
          $res->{err} = "Could not complete your request. Please check the input file: $_";
          $c->res->body(to_json($res));
          last;
        }
      }
    };
    # If any error occured, then rollback
    if($@) {
      eval( $c->config->{pneumodb_dbh}->rollback );
    }
  }

  if(!$res->{err}) {
    $c->config->{pneumodb_dbh}->commit();
  }

  $c->res->body(to_json($res));
}

sub uploadMLST {
  my ($c, $parsedData) = @_;
  my $res = {};
  $res->{rows_updated} = 0;
  # print Dumper $parsedData;
  eval {
    foreach my $lane (keys %$parsedData) {
      my $rows_affected;
      my $row = $parsedData->{$lane};
      try {
        my $rowString = '"'. join('","', @$row ) . '"';

        # Create quesry in-string to inject into the mysql query string
        my $q = qq{
          INSERT INTO pneumodb_results_mlst (prm_lane_id, prm_aroe_insilico, prm_gdh_insilico, prm_gki_insilico,
            prm_recp_insilico, prm_spi_insilico, prm_xpt_insilico, prm_ddl_insilico)
          VALUES ("$lane", $rowString)
            ON DUPLICATE KEY UPDATE
            prm_aroe_insilico = "$row->[0]",
            prm_gdh_insilico = "$row->[1]",
            prm_gki_insilico = "$row->[2]",
            prm_recp_insilico = "$row->[3]",
            prm_spi_insilico = "$row->[4]",
            prm_xpt_insilico = "$row->[5]",
            prm_ddl_insilico = "$row->[6]";
        };

        $rows_affected = $c->config->{pneumodb_dbh}->do($q) or die $!;
        if($rows_affected == 0  or $rows_affected eq '0E0') {
          push @{$res->{rows_not_updated}}, $lane;
        }
        else {
          $res->{rows_updated}++;
        }
      }
      catch {
        # Updated = 0 due to rollback
        $res->{rows_updated} = 0;
        $c->config->{pneumodb_dbh}->rollback();
        $res->{err} = "Could not complete your request. Please check the input file: $_";
        last;
      }
    }
  };
  # If any error occured, then rollback
  if($@) {
    eval( $c->config->{pneumodb_dbh}->rollback );
  }

  return $res;
}

sub uploadAntibiotic {
  my ($c, $parsedData) = @_;
  my $res = {};
  $res->{rows_updated} = 0;
  # print Dumper $parsedData;
  eval {
    foreach my $lane (keys %$parsedData) {
      my $rows_affected;
      my $parsedDataRow = $parsedData->{$lane};
      try {
        my $row = ();
        @$row = map { $_ eq "" ? 'null' : $_ } @$parsedDataRow;
        my $rowString = join(',',  @$row);

        # Create quesry in-string to inject into the mysql query string
        my $q = qq{
          INSERT INTO pneumodb_results_antibiotic (
            pra_lane_id,
            pra_VanS_F_1_AF155139,
            pra_aac3_IIa_X13543,
            pra_aacA_AB304512,
            pra_aac_3_IVa_1_X01385,
            pra_aac_6prime_Ii_1_L12710,
            pra_aac_6prime_aph_2primeprime__1_M13771,
            pra_aadA2,
            pra_aadB_1_JN119852,
            pra_aadD_1_AF181950,
            pra_ant_6_Ia_1_AF330699,
            pra_aph_3prime_III_1_M26832,
            pra_arsB_M86824,
            pra_blaTEM1_1_JF910132,
            pra_blaTEM33_1_GU371926,
            pra_blaZ_34_AP003139,
            pra_blaZ_35_AJ302698,
            pra_blaZ_36_AJ400722,
            pra_blaZ_39_BX571856,
            pra_cadA_BX571856,
            pra_cadD_BX571858,
            pra_catQ_1_M55620,
            pra_cat_5_U35036,
            pra_cat_pC194_1_NC_002013,
            pra_cat_pC221_1_X02529,
            pra_cat_pC233_1_AY355285,
            pra_catpC194_1_NC_002013,
            pra_catpC221_1_X02529,
            pra_catpC233_1_AY355285,
            pra_cmx_1_U85507,
            pra_dfrA12_1_AB571791,
            pra_dfrA14_1_DQ388123,
            pra_dfrC_1_GU565967,
            pra_dfrC_1_Z48233,
            pra_dfrG_1_AB205645,
            pra_ermA_2_AF002716,
            pra_ermB_10_U86375,
            pra_ermB_16_X82819,
            pra_ermB_18_X66468,
            pra_ermB_20_AF109075,
            pra_ermB_6_AF242872,
            pra_ermC_13_M13761,
            pra_fexA_1_AJ549214,
            pra_fosA_8_ACHE01000077,
            pra_fosB_1_X54227,
            pra_fusA_17_DQ866810,
            pra_fusB_1_AM292600,
            pra_fusD_AP008934,
            pra_ileS2_GU237136,
            pra_lnuA_1_M14039,
            pra_lsaC_1_HM990671,
            pra_mecA_10_AB512767,
            pra_mecA_15_AB505628,
            pra_mefA_10_AF376746,
            pra_mefA_3_AF227521,
            pra_mefE_AE007317,
            pra_merA_L29436,
            pra_merB_L29436,
            pra_merR_L29436,
            pra_mphA_1_D16251,
            pra_mphB_1_D85892,
            pra_mphC_2_AF167161,
            pra_msrA_1_X52085,
            pra_msrC_2_AF313494,
            pra_msrD_2_AF274302,
            pra_msrD_3_AF227520,
            pra_qacA_AP0003367,
            pra_qepA_1_AB263754,
            pra_smr_qacC_M37889,
            pra_strA_1_M96392,
            pra_strA_4_NC_003384,
            pra_strB_1_M96392,
            pra_str_1_X92946,
            pra_str_2_FN435330,
            pra_sul1_1_AY224185,
            pra_sul1_9_AY963803,
            pra_sul2_9_FJ197818,
            pra_tet32_2_EF626943,
            pra_tet38_3_FR821779,
            pra_tetB_4_AF326777,
            pra_tetG_4_AF133140,
            pra_tetK_4_U38428,
            pra_tetL_2_M29725,
            pra_tetL_6_X08034,
            pra_tetM_10_EU182585,
            pra_tetM_12_FR671418,
            pra_tetM_13_AM990992,
            pra_tetM_1_X92947,
            pra_tetM_2_X90939,
            pra_tetM_4_X75073,
            pra_tetM_5_U58985,
            pra_tetM_6_M21136,
            pra_tetM_8_X04388,
            pra_tetO_1_M18896,
            pra_tetO_3_Y07780,
            pra_tetR_sgi1,
            pra_tetS_3_X92946,
            pra_vgaA_1_M90056
          )
          VALUES ("$lane", $rowString)
            ON DUPLICATE KEY UPDATE
              pra_VanS_F_1_AF155139 = $row->[0],
              pra_aac3_IIa_X13543 = $row->[1],
              pra_aacA_AB304512 = $row->[2],
              pra_aac_3_IVa_1_X01385 = $row->[3],
              pra_aac_6prime_Ii_1_L12710 = $row->[4],
              pra_aac_6prime_aph_2primeprime__1_M13771 = $row->[5],
              pra_aadA2 = $row->[6],
              pra_aadB_1_JN119852 = $row->[7],
              pra_aadD_1_AF181950 = $row->[8],
              pra_ant_6_Ia_1_AF330699 = $row->[9],
              pra_aph_3prime_III_1_M26832 = $row->[10],
              pra_arsB_M86824 = $row->[11],
              pra_blaTEM1_1_JF910132 = $row->[12],
              pra_blaTEM33_1_GU371926 = $row->[13],
              pra_blaZ_34_AP003139 = $row->[14],
              pra_blaZ_35_AJ302698 = $row->[15],
              pra_blaZ_36_AJ400722 = $row->[16],
              pra_blaZ_39_BX571856 = $row->[17],
              pra_cadA_BX571856 = $row->[18],
              pra_cadD_BX571858 = $row->[19],
              pra_catQ_1_M55620 = $row->[20],
              pra_cat_5_U35036 = $row->[21],
              pra_cat_pC194_1_NC_002013 = $row->[22],
              pra_cat_pC221_1_X02529 = $row->[23],
              pra_cat_pC233_1_AY355285 = $row->[24],
              pra_catpC194_1_NC_002013 = $row->[25],
              pra_catpC221_1_X02529 = $row->[26],
              pra_catpC233_1_AY355285 = $row->[27],
              pra_cmx_1_U85507 = $row->[28],
              pra_dfrA12_1_AB571791 = $row->[29],
              pra_dfrA14_1_DQ388123 = $row->[30],
              pra_dfrC_1_GU565967 = $row->[31],
              pra_dfrC_1_Z48233 = $row->[32],
              pra_dfrG_1_AB205645 = $row->[33],
              pra_ermA_2_AF002716 = $row->[34],
              pra_ermB_10_U86375 = $row->[35],
              pra_ermB_16_X82819 = $row->[36],
              pra_ermB_18_X66468 = $row->[37],
              pra_ermB_20_AF109075 = $row->[38],
              pra_ermB_6_AF242872 = $row->[39],
              pra_ermC_13_M13761 = $row->[40],
              pra_fexA_1_AJ549214 = $row->[41],
              pra_fosA_8_ACHE01000077 = $row->[42],
              pra_fosB_1_X54227 = $row->[43],
              pra_fusA_17_DQ866810 = $row->[44],
              pra_fusB_1_AM292600 = $row->[45],
              pra_fusD_AP008934 = $row->[46],
              pra_ileS2_GU237136 = $row->[47],
              pra_lnuA_1_M14039 = $row->[48],
              pra_lsaC_1_HM990671 = $row->[49],
              pra_mecA_10_AB512767 = $row->[50],
              pra_mecA_15_AB505628 = $row->[51],
              pra_mefA_10_AF376746 = $row->[52],
              pra_mefA_3_AF227521 = $row->[53],
              pra_mefE_AE007317 = $row->[54],
              pra_merA_L29436 = $row->[55],
              pra_merB_L29436 = $row->[56],
              pra_merR_L29436 = $row->[57],
              pra_mphA_1_D16251 = $row->[58],
              pra_mphB_1_D85892 = $row->[59],
              pra_mphC_2_AF167161 = $row->[60],
              pra_msrA_1_X52085 = $row->[61],
              pra_msrC_2_AF313494 = $row->[62],
              pra_msrD_2_AF274302 = $row->[63],
              pra_msrD_3_AF227520 = $row->[64],
              pra_qacA_AP0003367 = $row->[65],
              pra_qepA_1_AB263754 = $row->[66],
              pra_smr_qacC_M37889 = $row->[67],
              pra_strA_1_M96392 = $row->[68],
              pra_strA_4_NC_003384 = $row->[69],
              pra_strB_1_M96392 = $row->[70],
              pra_str_1_X92946 = $row->[71],
              pra_str_2_FN435330 = $row->[72],
              pra_sul1_1_AY224185 = $row->[73],
              pra_sul1_9_AY963803 = $row->[74],
              pra_sul2_9_FJ197818 = $row->[75],
              pra_tet32_2_EF626943 = $row->[76],
              pra_tet38_3_FR821779 = $row->[77],
              pra_tetB_4_AF326777 = $row->[78],
              pra_tetG_4_AF133140 = $row->[79],
              pra_tetK_4_U38428 = $row->[80],
              pra_tetL_2_M29725 = $row->[81],
              pra_tetL_6_X08034 = $row->[82],
              pra_tetM_10_EU182585 = $row->[83],
              pra_tetM_12_FR671418 = $row->[84],
              pra_tetM_13_AM990992 = $row->[85],
              pra_tetM_1_X92947 = $row->[86],
              pra_tetM_2_X90939 = $row->[87],
              pra_tetM_4_X75073 = $row->[88],
              pra_tetM_5_U58985 = $row->[89],
              pra_tetM_6_M21136 = $row->[90],
              pra_tetM_8_X04388 = $row->[91],
              pra_tetO_1_M18896 = $row->[92],
              pra_tetO_3_Y07780 = $row->[93],
              pra_tetR_sgi1 = $row->[94],
              pra_tetS_3_X92946 = $row->[95],
              pra_vgaA_1_M90056 = $row->[96]
        };

        $rows_affected = $c->config->{pneumodb_dbh}->do($q) or die $!;
        if($rows_affected == 0  or $rows_affected eq '0E0') {
          push @{$res->{rows_not_updated}}, $lane;
        }
        else {
          $res->{rows_updated}++;
        }
      }
      catch {
        # Updated = 0 due to rollback
        $res->{rows_updated} = 0;
        $c->config->{pneumodb_dbh}->rollback();
        $res->{err} = "Could not complete your request. Please check the input file: $_";
        last;
      }
    }
  };
  # If any error occured, then rollback
  if($@) {
    eval( $c->config->{pneumodb_dbh}->rollback );
  }

  return $res;
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
