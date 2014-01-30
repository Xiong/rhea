#!/usr/bin/env perl
#       play-getopt-long.pl
#       = Copyright 2014 Xiong Changnian  <xiong@cpan.org>   =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.014002;   # 5.14.2    # 2012  # pop $arrayref, copy s///r
use strict;
use warnings;

#~ use lib qw| lib |;
#~ use Error::Base;
#~ use Perl6::Form;
#~ use Test::More;
#~ use Test::Trap;

use Devel::Comments '###';
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
say "$0 Running...";

use Getopt::Long                            # Parses command-line options
    qw( GetOptionsFromArray ),          # not directly from @ARGV
    qw( :config bundling ),             # enable, for instance, -xyz
    qw( require_order pass_through);    # terminate processing on non-options
use Pod::Usage;                             # Build help text from POD
use Pod::Find qw{pod_where};                # POD is in ...

our $Debug          = 0;
my $cli       = {
    'help|h+'       => q{Try -h, -hh, -hhh for more help.},
    'version|v'     => q{Print PLAY version and exit.},
    'debug|d+'      => q{Print verbose debugging info.},
    'all|a'         => q{Execute git subcommand over all submods.},
};

    my @args            = @ARGV    or die 'Usage:...';
    my @opt_setup       = keys %$cli;
    my $opt             = {};   # option keys and maybe config
    my $opt_rv          ;       # return value from Getopt

    # Parse options out of passed-in copy of @ARGV.
    $opt_rv     = GetOptionsFromArray( \@args, $opt, @opt_setup );
    
    # General action tree.
    if ( exists $opt->{debug} )     { $Debug          = $opt->{debug}       };
    if ( exists $opt->{help} )      { _help( $opt->{help} );   return 0     }; 
    if ( exists $opt->{version} )   { _output(200);            return 0     }; 

### $opt_rv
### $opt
### @args

say "Done.";
exit;
#----------------------------------------------------------------------------#


#============================================================================#
__END__     
