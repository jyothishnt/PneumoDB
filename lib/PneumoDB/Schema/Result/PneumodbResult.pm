use utf8;
package PneumoDB::Schema::Result::PneumodbResult;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PneumoDB::Schema::Result::PneumodbResult

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

=head1 TABLE: C<pneumodb_results>

=cut

__PACKAGE__->table("pneumodb_results");

=head1 ACCESSORS

=head2 prs_sanger_id

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 prs_lane_id

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 prs_pneumo_qc

  data_type: 'text'
  is_nullable: 1

=head2 prs_comments

  data_type: 'text'
  is_nullable: 1

=head2 prs_in_silico_st

  data_type: 'text'
  is_nullable: 1

=head2 prs_in_silico_serotype

  data_type: 'text'
  is_nullable: 1

=head2 prs_sample_outcome

  data_type: 'text'
  is_nullable: 1

=head2 prs_updated_on

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 prs_dbupdate_comments

  data_type: 'text'
  is_nullable: 1

=head2 prs_baps_1

  data_type: 'text'
  is_nullable: 1

=head2 prs_baps_2

  data_type: 'text'
  is_nullable: 1

=head2 prs_vaccine_status

  data_type: 'text'
  is_nullable: 1

=head2 prs_vaccine_period

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "prs_sanger_id",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "prs_lane_id",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "prs_pneumo_qc",
  { data_type => "text", is_nullable => 1 },
  "prs_comments",
  { data_type => "text", is_nullable => 1 },
  "prs_in_silico_st",
  { data_type => "text", is_nullable => 1 },
  "prs_in_silico_serotype",
  { data_type => "text", is_nullable => 1 },
  "prs_sample_outcome",
  { data_type => "text", is_nullable => 1 },
  "prs_updated_on",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "prs_dbupdate_comments",
  { data_type => "text", is_nullable => 1 },
  "prs_baps_1",
  { data_type => "text", is_nullable => 1 },
  "prs_baps_2",
  { data_type => "text", is_nullable => 1 },
  "prs_vaccine_status",
  { data_type => "text", is_nullable => 1 },
  "prs_vaccine_period",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-15 10:29:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+bS52wLl6gQg9nldfD28Cw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
