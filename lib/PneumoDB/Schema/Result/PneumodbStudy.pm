use utf8;
package PneumoDB::Schema::Result::PneumodbStudy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PneumoDB::Schema::Result::PneumodbStudy

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

=head1 TABLE: C<pneumodb_studies>

=cut

__PACKAGE__->table("pneumodb_studies");

=head1 ACCESSORS

=head2 pst_study_id

  data_type: 'integer'
  is_nullable: 0

=head2 pst_study_name

  data_type: 'text'
  is_nullable: 1

=head2 pst_study_data_source

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pst_study_id",
  { data_type => "integer", is_nullable => 0 },
  "pst_study_name",
  { data_type => "text", is_nullable => 1 },
  "pst_study_data_source",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pst_study_id>

=back

=cut

__PACKAGE__->set_primary_key("pst_study_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-15 15:55:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J4+ruBLft3ZrEzzzt0YsYw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
