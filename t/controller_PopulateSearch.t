use strict;
use warnings;
use Test::More;


use Catalyst::Test 'DBConnect';
use DBConnect::Controller::PopulateSearch;

ok( request('/populatesearch')->is_success, 'Request should succeed' );
done_testing();
