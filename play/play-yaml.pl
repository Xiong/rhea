#!/usr/bin/env perl
#       play-yaml.pl
#       = Copyright 2014 Xiong Changnian  <xiong@cpan.org>   =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.014002;   # 5.14.2    # 2012  # pop $arrayref, copy s///r
use strict;
use warnings;

#~ use lib qw| lib ../lib |;
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

#   key             key in config hashref
#   query           question text shown to user
#   resort          default if default cannot be calculated
#   help            explanation shown to user if user types '?' in response
#                   blank line required at end of block
my $aref    = [
    {
        key     => q{dog-color},
        query   => q{What color is your dog?},
        resort  => q{blue},
        help    => q{Most users have one or more dogs. If you have no dog then press space and enter. If you have several dogs then enter the color of your first dog. If you are unsure of the color of your dog then just press return to accept the default.},
    },

    {
        key     => q{user-name},
        query   => q{What is your name?},
        help    => q{You must choose a user name. This will be used to report you to the NSA. No default value is available.},
    },


    {
        key     => q{user-pass},
        query   => q{What is your password?},
        resort  => q{},
        help    => q{You may choose to set a password. If so, it must be 3 to 8 uppercase letters not including 'q' and end in 'z'. Press return to skip setting a password. NOTE: Accounts without passwords are inherently insecure.},
    },
    
    {
        key     => q{dummy},
        query   => q{Who me, fool?},
        resort  => undef,
    },

    {
        key     => q{tilde},
        query   => q{What's a tilde?},
        resort  => q{~},
    },

];
#~ ### $aref

my $yaml    = Dump($aref);

print $yaml;

say "Done.";
exit;
#----------------------------------------------------------------------------#


#============================================================================#
__END__     

---
- help: Most users have one or more dogs. If you have no dog then press space and
    enter. If you have several dogs then enter the color of your first dog. If you
    are unsure of the color of your dog then just press return to accept the default.
  key: dog-color
  query: What color is your dog?
  resort: blue
- help: You must choose a user name. This will be used to report you to the NSA. No
    default value is available.
  key: user-name
  query: What is your name?
- help: 'You may choose to set a password. If so, it must be 3 to 8 uppercase letters
    not including ''q'' and end in ''z''. Press return to skip setting a password.
    NOTE: Accounts without passwords are inherently insecure.'
  key: user-pass
  query: What is your password?
  resort: ''
- key: dummy
  query: Who me, fool?
  resort: ~
- key: tilde
  query: What's a tilde?
  resort: '~'
