#!/usr/bin/env perl
#       play-2014.pl
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

use Cwd;                # Get current working directory = cwd();
use File::Spec;         # Portable OO methods on filenames
use File::Path          # Create or remove directory trees
    qw| make_path remove_tree |;

#~ use Devel::Comments '###';
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# GLOBALS   
my $rhea_prompt     = q{#$ };

#----------------------------------------------------------------------------#
say "$0 Running...";

# scratch variables
my $cmd         ;
my $args        ;
my @rv          ;

# Make a temporary working dir for fooling around in.
my $rootdir     = cwd();
my $workdir     = File::Spec->catdir( $rootdir, 'rheatmp' );
remove_tree( $workdir, { safe => 0 } ); # must chmod to rm read-only files
mkdir $workdir 
    or die "Failed to mkdir $workdir";
chdir $workdir;
say "Working in $workdir";
_shell( 'ls -lA' );

_shell( 'git init' );
_shell( 'git status' );

_shell( 'touch dummy' );
_shell( 'git status' );

_shell( 'git add .' );                          # stage
_shell( 'git status' );

_shell( 'git commit -a -m "Dummy commit."' );   # commit

_shell( 'git status' );
#~ _shell( 'gitk' );

say "Done.";
exit;
#----------------------------------------------------------------------------#
# SUBS

#=========# INTERNAL ROUTINE
#
#~     _shell( $command );
#       
# Just shell out and allow caller to see output. (transparent)
# 
sub _shell {
    my $line    = shift;
    
    say $rhea_prompt . $line;
    system $line;
    
}; ## _shell

#=========# INTERNAL ROUTINE
#
#~     _do_();     # short
#       
# ____
# 
sub _do_ {
    
    
    
}; ## _do_



#============================================================================#
__END__     
