use utf8;
package PneumoDB::Schema::Result::PneumodbCoordinates;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PneumoDB::Schema::Result::PneumodbCoordinates

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

=head1 TABLE: C<pneumodb_coordinates>

=cut

__PACKAGE__->table("pneumodb_coordinates");

=head1 ACCESSORS

=head2 pco_location

  data_type: 'text'
  is_nullable: 1

=head2 pco_latitude

  data_type: 'float'
  is_nullable: 1

=head2 pco_longitude

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pco_location",
  { data_type => "text", is_nullable => 1 },
  "pco_latitude",
  { data_type => "float", is_nullable => 1 },
  "pco_longitude",
  { data_type => "float", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-22 15:46:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7zO0+KXAEh2ce/IwSc1HXg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
