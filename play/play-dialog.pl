#!/usr/bin/env perl
#       play-dialog.pl
#       = Copyright 2014 Xiong Changnian  <xiong@cpan.org>   =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.014002;   # 5.14.2    # 2012  # pop $arrayref, copy s///r
use strict;
use warnings;

#~ use lib qw| lib |;
use YAML::XS;           # Perl YAML Serialization using XS and libyaml

#~ use Error::Base;
#~ use Perl6::Form;
#~ use Test::More;
#~ use Test::Trap;

use Devel::Comments '###';
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
say "$0 Running...";

my $yaml        ;
{
    local $/        = undef;            # slurp
    $yaml           = <DATA>;
}

my $aref        = YAML::XS::Load($yaml);

### $aref

say "Done.";
exit;
#----------------------------------------------------------------------------#


#============================================================================#
__END__
---
-
    key:    dog-color
    query:  What color is your dog?
    resort: blue
    help: >
        Most users have one or more dogs. If you have no dog then press
        space and enter. If you have several dogs then enter the color of
        your first dog. If you are unsure of the color of your dog then
        just press return to accept the default.
-
    key:    user-name
    query:  What is your name?
    help: >
        You must choose a user name. This will be used to report you to
        the NSA. No default value is available.
  


