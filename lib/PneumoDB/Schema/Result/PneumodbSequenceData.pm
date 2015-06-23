use utf8;
package PneumoDB::Schema::Result::PneumodbSequenceData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PneumoDB::Schema::Result::PneumodbSequenceData

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

=head1 TABLE: C<pneumodb_sequence_data>

=cut

__PACKAGE__->table("pneumodb_sequence_data");

=head1 ACCESSORS

=head2 psd_lane_id

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 psd_sanger_id

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 psd_public_name

  data_type: 'text'
  is_nullable: 0

=head2 psd_accessionfind_no_duplicates

  data_type: 'integer'
  is_nullable: 1

=head2 psd_ers

  data_type: 'text'
  is_nullable: 1

=head2 psd_err

  data_type: 'text'
  is_nullable: 1

=head2 psd_mapfind_no_duplicates

  data_type: 'integer'
  is_nullable: 1

=head2 psd_reference

  data_type: 'text'
  is_nullable: 1

=head2 psd_mapped_perc

  data_type: 'float'
  is_nullable: 1

=head2 psd_depth_of_coverage

  data_type: 'text'
  is_nullable: 1

=head2 psd_depth_of_coverage_sd

  data_type: 'text'
  is_nullable: 1

=head2 psd_assfind_no_duplicates

  data_type: 'integer'
  is_nullable: 1

=head2 psd_total_length

  data_type: 'integer'
  is_nullable: 1

=head2 psd_no_contigs

  data_type: 'integer'
  is_nullable: 1

=head2 psd_n50

  data_type: 'integer'
  is_nullable: 1

=head2 psd_pathfind_no_duplicates

  data_type: 'integer'
  is_nullable: 1

=head2 psd_npg_qc

  data_type: 'text'
  is_nullable: 1

=head2 psd_manual_qc

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "psd_lane_id",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "psd_sanger_id",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "psd_public_name",
  { data_type => "text", is_nullable => 0 },
  "psd_accessionfind_no_duplicates",
  { data_type => "integer", is_nullable => 1 },
  "psd_ers",
  { data_type => "text", is_nullable => 1 },
  "psd_err",
  { data_type => "text", is_nullable => 1 },
  "psd_mapfind_no_duplicates",
  { data_type => "integer", is_nullable => 1 },
  "psd_reference",
  { data_type => "text", is_nullable => 1 },
  "psd_mapped_perc",
  { data_type => "float", is_nullable => 1 },
  "psd_depth_of_coverage",
  { data_type => "text", is_nullable => 1 },
  "psd_depth_of_coverage_sd",
  { data_type => "text", is_nullable => 1 },
  "psd_assfind_no_duplicates",
  { data_type => "integer", is_nullable => 1 },
  "psd_total_length",
  { data_type => "integer", is_nullable => 1 },
  "psd_no_contigs",
  { data_type => "integer", is_nullable => 1 },
  "psd_n50",
  { data_type => "integer", is_nullable => 1 },
  "psd_pathfind_no_duplicates",
  { data_type => "integer", is_nullable => 1 },
  "psd_npg_qc",
  { data_type => "text", is_nullable => 1 },
  "psd_manual_qc",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-22 14:51:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oA6+5DE7/iPySXBm0LEX2A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
