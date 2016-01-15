use utf8;
package PneumoDB::Schema::Result::PneumodbResultsMlst;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PneumoDB::Schema::Result::PneumodbResultsMlst

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

=head1 TABLE: C<pneumodb_results_mlst>

=cut

__PACKAGE__->table("pneumodb_results_mlst");

=head1 ACCESSORS

=head2 prm_lane_id

  data_type: 'text'
  is_nullable: 1

=head2 prm_aroe_insilico

  data_type: 'text'
  is_nullable: 1

=head2 prm_gdh_insilico

  data_type: 'text'
  is_nullable: 1

=head2 prm_gki_insilico

  data_type: 'text'
  is_nullable: 1

=head2 prm_recp_insilico

  data_type: 'text'
  is_nullable: 1

=head2 prm_spi_insilico

  data_type: 'text'
  is_nullable: 1

=head2 prm_xpt_insilico

  data_type: 'text'
  is_nullable: 1

=head2 prm_ddl_insilico

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "prm_lane_id",
  { data_type => "text", is_nullable => 1 },
  "prm_aroe_insilico",
  { data_type => "text", is_nullable => 1 },
  "prm_gdh_insilico",
  { data_type => "text", is_nullable => 1 },
  "prm_gki_insilico",
  { data_type => "text", is_nullable => 1 },
  "prm_recp_insilico",
  { data_type => "text", is_nullable => 1 },
  "prm_spi_insilico",
  { data_type => "text", is_nullable => 1 },
  "prm_xpt_insilico",
  { data_type => "text", is_nullable => 1 },
  "prm_ddl_insilico",
  { data_type => "text", is_nullable => 1 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<prm_index>

=over 4

=item * L</prm_lane_id>

=back

=cut

__PACKAGE__->add_unique_constraint("prm_index", ["prm_lane_id"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-15 12:33:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:g/3PUiXA8t+jbdsRLXWv4A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
