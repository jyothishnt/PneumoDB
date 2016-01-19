use utf8;
package PneumoDB::Schema::Result::PneumodbMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PneumoDB::Schema::Result::PneumodbMetadata

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<pneumodb_metadata>

=cut

__PACKAGE__->table("pneumodb_metadata");

=head1 ACCESSORS

=head2 pmd_sample_id

  data_type: 'text'
  is_nullable: 1

=head2 pmd_public_name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 pmd_study_name

  data_type: 'text'
  is_nullable: 1

=head2 pmd_selection_random

  data_type: 'text'
  is_nullable: 1

=head2 pmd_country

  data_type: 'text'
  is_nullable: 1

=head2 pmd_region

  data_type: 'text'
  is_nullable: 1

=head2 pmd_city

  data_type: 'text'
  is_nullable: 1

=head2 pmd_facility_collected

  data_type: 'text'
  is_nullable: 1

=head2 pmd_institution

  data_type: 'text'
  is_nullable: 1

=head2 pmd_col_month

  data_type: 'text'
  is_nullable: 1

=head2 pmd_col_year

  data_type: 'text'
  is_nullable: 1

=head2 pmd_gender

  data_type: 'text'
  is_nullable: 1

=head2 pmd_age_year

  data_type: 'text'
  is_nullable: 1

=head2 pmd_age_month

  data_type: 'text'
  is_nullable: 1

=head2 pmd_age_day

  data_type: 'text'
  is_nullable: 1

=head2 pmd_clinical_manifest

  data_type: 'text'
  is_nullable: 1

=head2 pmd_source

  data_type: 'text'
  is_nullable: 1

=head2 pmd_hiv_status

  data_type: 'text'
  is_nullable: 1

=head2 pmd_conditions

  data_type: 'text'
  is_nullable: 1

=head2 pmd_pheno_serotype_method

  data_type: 'text'
  is_nullable: 1

=head2 pmd_pheno_serotype

  data_type: 'text'
  is_nullable: 1

=head2 pmd_seq_type

  data_type: 'text'
  is_nullable: 1

=head2 pmd_aroe

  data_type: 'text'
  is_nullable: 1

=head2 pmd_gdh

  data_type: 'text'
  is_nullable: 1

=head2 pmd_gki

  data_type: 'text'
  is_nullable: 1

=head2 pmd_recp

  data_type: 'text'
  is_nullable: 1

=head2 pmd_spi

  data_type: 'text'
  is_nullable: 1

=head2 pmd_xpt

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ddl

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_penicillin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_penicillin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_amoxicillin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_amoxicillin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_cefotaxime

  data_type: 'text'
  is_nullable: 1

=head2 pmd_cefotaxime

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_ceftriaxone

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ceftriaxone

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_cefuroxime

  data_type: 'text'
  is_nullable: 1

=head2 pmd_cefuroxime

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_meropenem

  data_type: 'text'
  is_nullable: 1

=head2 pmd_meropenem

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_erythromycin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_erythromycin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_clindamycin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_clindamycin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_trim_sulfa

  data_type: 'text'
  is_nullable: 1

=head2 pmd_trim_sulfa

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_vancomycin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_vancomycin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_linezolid

  data_type: 'text'
  is_nullable: 1

=head2 pmd_linezolid

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_ciprofloxacin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ciprofloxacin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_chloramphenicol

  data_type: 'text'
  is_nullable: 1

=head2 pmd_chloramphenicol

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_tetracycline

  data_type: 'text'
  is_nullable: 1

=head2 pmd_tetracycline

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_levofloxacin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_levofloxacin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_synercid

  data_type: 'text'
  is_nullable: 1

=head2 pmd_synercid

  data_type: 'text'
  is_nullable: 1

=head2 pmd_ast_rifampin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_rifampin

  data_type: 'text'
  is_nullable: 1

=head2 pmd_comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pmd_sample_id",
  { data_type => "text", is_nullable => 1 },
  "pmd_public_name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "pmd_study_name",
  { data_type => "text", is_nullable => 1 },
  "pmd_selection_random",
  { data_type => "text", is_nullable => 1 },
  "pmd_country",
  { data_type => "text", is_nullable => 1 },
  "pmd_region",
  { data_type => "text", is_nullable => 1 },
  "pmd_city",
  { data_type => "text", is_nullable => 1 },
  "pmd_facility_collected",
  { data_type => "text", is_nullable => 1 },
  "pmd_institution",
  { data_type => "text", is_nullable => 1 },
  "pmd_col_month",
  { data_type => "text", is_nullable => 1 },
  "pmd_col_year",
  { data_type => "text", is_nullable => 1 },
  "pmd_gender",
  { data_type => "text", is_nullable => 1 },
  "pmd_age_year",
  { data_type => "text", is_nullable => 1 },
  "pmd_age_month",
  { data_type => "text", is_nullable => 1 },
  "pmd_age_day",
  { data_type => "text", is_nullable => 1 },
  "pmd_clinical_manifest",
  { data_type => "text", is_nullable => 1 },
  "pmd_source",
  { data_type => "text", is_nullable => 1 },
  "pmd_hiv_status",
  { data_type => "text", is_nullable => 1 },
  "pmd_conditions",
  { data_type => "text", is_nullable => 1 },
  "pmd_pheno_serotype_method",
  { data_type => "text", is_nullable => 1 },
  "pmd_pheno_serotype",
  { data_type => "text", is_nullable => 1 },
  "pmd_seq_type",
  { data_type => "text", is_nullable => 1 },
  "pmd_aroe",
  { data_type => "text", is_nullable => 1 },
  "pmd_gdh",
  { data_type => "text", is_nullable => 1 },
  "pmd_gki",
  { data_type => "text", is_nullable => 1 },
  "pmd_recp",
  { data_type => "text", is_nullable => 1 },
  "pmd_spi",
  { data_type => "text", is_nullable => 1 },
  "pmd_xpt",
  { data_type => "text", is_nullable => 1 },
  "pmd_ddl",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_penicillin",
  { data_type => "text", is_nullable => 1 },
  "pmd_penicillin",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_amoxicillin",
  { data_type => "text", is_nullable => 1 },
  "pmd_amoxicillin",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_cefotaxime",
  { data_type => "text", is_nullable => 1 },
  "pmd_cefotaxime",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_ceftriaxone",
  { data_type => "text", is_nullable => 1 },
  "pmd_ceftriaxone",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_cefuroxime",
  { data_type => "text", is_nullable => 1 },
  "pmd_cefuroxime",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_meropenem",
  { data_type => "text", is_nullable => 1 },
  "pmd_meropenem",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_erythromycin",
  { data_type => "text", is_nullable => 1 },
  "pmd_erythromycin",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_clindamycin",
  { data_type => "text", is_nullable => 1 },
  "pmd_clindamycin",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_trim_sulfa",
  { data_type => "text", is_nullable => 1 },
  "pmd_trim_sulfa",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_vancomycin",
  { data_type => "text", is_nullable => 1 },
  "pmd_vancomycin",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_linezolid",
  { data_type => "text", is_nullable => 1 },
  "pmd_linezolid",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_ciprofloxacin",
  { data_type => "text", is_nullable => 1 },
  "pmd_ciprofloxacin",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_chloramphenicol",
  { data_type => "text", is_nullable => 1 },
  "pmd_chloramphenicol",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_tetracycline",
  { data_type => "text", is_nullable => 1 },
  "pmd_tetracycline",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_levofloxacin",
  { data_type => "text", is_nullable => 1 },
  "pmd_levofloxacin",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_synercid",
  { data_type => "text", is_nullable => 1 },
  "pmd_synercid",
  { data_type => "text", is_nullable => 1 },
  "pmd_ast_rifampin",
  { data_type => "text", is_nullable => 1 },
  "pmd_rifampin",
  { data_type => "text", is_nullable => 1 },
  "pmd_comments",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-19 11:43:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3SRv8qEP51SHu6SqxOVOgg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
