use strict;
use warnings;
#~ use diagnostics;

use Test::More;
my $tc;
my $got;
warn "\n";

$tc++;
$got    = undef;
warn "(foo)\n";
$got = <STDIN>;
chomp $got;
is( $got, 'foo' );

$tc++;
$got    = undef;
warn "(bar)\n";
$got = <STDIN>;
chomp $got;
is( $got, 'bar' );


done_testing($tc);
