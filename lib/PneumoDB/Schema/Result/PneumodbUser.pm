use utf8;
package PneumoDB::Schema::Result::PneumodbUser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PneumoDB::Schema::Result::PneumodbUser

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

=head1 TABLE: C<pneumodb_users>

=cut

__PACKAGE__->table("pneumodb_users");

=head1 ACCESSORS

=head2 pnu_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 pnu_username

  data_type: 'text'
  is_nullable: 1

=head2 pnu_password

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 pnu_email_address

  data_type: 'text'
  is_nullable: 1

=head2 pnu_name

  data_type: 'text'
  is_nullable: 1

=head2 pnu_institution

  data_type: 'text'
  is_nullable: 1

=head2 pnu_country

  data_type: 'text'
  is_nullable: 1

=head2 pnu_role

  data_type: 'text'
  is_nullable: 1

=head2 pnu_active

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pnu_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "pnu_username",
  { data_type => "text", is_nullable => 1 },
  "pnu_password",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "pnu_email_address",
  { data_type => "text", is_nullable => 1 },
  "pnu_name",
  { data_type => "text", is_nullable => 1 },
  "pnu_institution",
  { data_type => "text", is_nullable => 1 },
  "pnu_country",
  { data_type => "text", is_nullable => 1 },
  "pnu_role",
  { data_type => "text", is_nullable => 1 },
  "pnu_active",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pnu_id>

=back

=cut

__PACKAGE__->set_primary_key("pnu_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-19 11:43:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+bkjUmVMXpWgObmMJCkBGA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
