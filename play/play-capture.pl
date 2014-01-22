#!/usr/bin/env perl
#       play-capture.pl
#       = Copyright 2014 Xiong Changnian  <xiong@cpan.org>   =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.014002;   # 5.14.2    # 2012  # pop $arrayref, copy s///r
use strict;
use warnings;

use lib qw| lib |;
use Error::Base;
use Perl6::Form;
use Test::More;
use Test::Trap qw| :default |;;

#~ use Devel::Comments '###';
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
say "$0 Running...";

my $rhea_token      = q{%# };
my $tmpdir          = q{rheatmp};
my $git_name        = q{git};
my $shrd            = q{ 2>&1};         # bash shell redirect
my @outlines        ;

trap{
    push @outlines, $rhea_token . `mkdir $tmpdir $shrd`;
    chdir $tmpdir
        or push @outlines, $rhea_token . "Failed to chdir to $tmpdir";
    push @outlines, $rhea_token . `$git_name init $shrd`;
    
    chomp @outlines;
    say for @outlines;
};

say "Done.";
exit;
#----------------------------------------------------------------------------#


#============================================================================#
__END__     
