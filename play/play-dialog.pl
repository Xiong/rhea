#!/usr/bin/env perl
#       play-dialog.pl
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

# Dialog strings used to initialize rhea. 
# Lines *starting* with '#' are ignored. 
# Only help text can be multi-line.
my $dialog_here     = <<HERE;
#   key             key in config hashref
#   query           question text shown to user
#   resort          default if default cannot be calculated
#   help            explanation shown to user if user types '?' in response
#                   blank line required at end of block

dog-color
What color is your dog?
blue
Most users have one or more dogs. If you have no dog then press space and 
enter. If you have several dogs then enter the color of your first dog. If 
you are unsure of the color of your dog then just press return to accept 
the default. 

user-name
What is your name?
<none>
You must choose a user name. This will be used to report you to the NSA. 
No default value is available. 

user-pass
What is your password?
<empty>
You may choose to set a password. If so, it must be 3 to 8 uppercase 
letters not including 'q' and end in 'z'. Press return to skip setting a 
password. NOTE: Accounts without passwords are inherently insecure.

HERE

my $bs          = qq{\00};              # block separator
$dialog_here    =~ s/\n\n/$bs/g;        # replace blank lines with ASCII NUL
$dialog_here    =~ s/^#[^\n]*\n$//msg;          # strip (full-line) comments
my @dialog_ary  = split $bs, $dialog_here;      # split into blocks
my $dialog      ;

#~ ### @dialog_ary
for (@dialog_ary) {
    my $block       = $_;
    ### $block
    
    next if not $block;                             # discard empty blocks
    my $href        = {};
    my @lines       = split qq{\n}, $block;         # split into lines
    ### @lines
    
    # Set.
    $href->{key}    = shift @lines;
    $href->{query}  = shift @lines;
    $href->{resort} = shift @lines;
    $href->{help}   = join qq{\n}, @lines;          # help can be multi-line
    
    # Check and fix.
    ( defined $href->{key} and defined $href->{query} )
        or die    "Failed to parse dialog block:\n"
                . $block
                . '==='
                ;
    for ( keys $href ) {
        if ( not defined $href->{$_}  ) {                       next;   };
        if ( $href->{$_} eq '<none>'  ) { $href->{$_} = undef;  next;   };
        if ( $href->{$_} eq '<empty>' ) { $href->{$_} = q{};    next;   };
    };
    push @$dialog, $href;
};
### $dialog


say "Done.";
exit;
#----------------------------------------------------------------------------#


#============================================================================#
__END__     
