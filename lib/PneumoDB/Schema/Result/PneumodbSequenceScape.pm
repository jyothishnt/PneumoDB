use utf8;
package PneumoDB::Schema::Result::PneumodbSequenceScape;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PneumoDB::Schema::Result::PneumodbSequenceScape

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

=head1 TABLE: C<pneumodb_sequence_scape>

=cut

__PACKAGE__->table("pneumodb_sequence_scape");

=head1 ACCESSORS

=head2 pss_study_id

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 pss_sanger_id

  data_type: 'text'
  is_nullable: 1

=head2 pss_public_name

  data_type: 'text'
  is_nullable: 1

=head2 pss_lane_id

  data_type: 'text'
  is_nullable: 0

=head2 pss_q20_yield_forward_read

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 pss_q20_yield_reverse_read

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 pss_total_yield

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 pss_created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pss_study_id",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "pss_sanger_id",
  { data_type => "text", is_nullable => 1 },
  "pss_public_name",
  { data_type => "text", is_nullable => 1 },
  "pss_lane_id",
  { data_type => "text", is_nullable => 0 },
  "pss_q20_yield_forward_read",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "pss_q20_yield_reverse_read",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "pss_total_yield",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "pss_created",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</pss_lane_id>

=back

=cut

__PACKAGE__->set_primary_key("pss_lane_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-20 14:15:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/qWRx29qmtjSOslw5ZC8bQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
