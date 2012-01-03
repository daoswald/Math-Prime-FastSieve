
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Math-Prime-FastSieve.t'

#########################


use strict;
use warnings;

use Test::More tests => 1;
BEGIN { use_ok('Math::Prime::FastSieve') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

done_testing();
