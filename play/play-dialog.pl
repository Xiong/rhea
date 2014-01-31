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

my $cfg         = {};
for (@$aref) {
    my $href        = $_;
    my $key         = $href->{key};
    my $query       = $href->{query};
    my $value       = $cfg->{$key}      || $href->{resort};
    my $valid       = $href->{valid};
    my $help        = $href->{help};
    
    $value          = _query({
        query           => $query,
        value           => $value,
        valid           => $valid,
        help            => $help,
    });
    $cfg->{$key}    = $value;
};
### $cfg

say "Done.";
exit;
#----------------------------------------------------------------------------#

#=========# INTERNAL ROUTINE
#
#~     $value          = _query({
#~         query           => $query,
#~         value           => $value,
#~         valid           => $valid,
#~         help            => $help,
#~     });
#       
# Purpose   : Interrogate user until a value is obtained.
# Parms     : 
#       query   : string    : question text including '?' if needed
#       value   : scalar    : default value suggested to user
#       valid   : regex     : value must match this
#       help    : string    : text displayed if user demands help
# Returns   : $value    : scalar
# See also  : ____
# 
# Offer query and value to user at console until success. 
# If user types '?', display help and retry.
# If user types nothing, accept default value and succeed.
# 
sub _query {
    my $args        = shift;
#~     ### $args
    my $query       = $args->{query}    or die 'Failed to ask anything';
    my $value       = $args->{value}    || q{};
    my $valid       = $args->{valid};
    my $help        = $args->{help}     || 'Sorry, no help for this.';
    my $help_demand = '?';
    
    local $|        = 1;                # autoflush
    
    while (1) {
        print $query, ' [', $value, '] ';
        my $in      = <STDIN>;
#~         ### $in
        chomp $in;
        if ( $in eq $help_demand ) {
            say $help;
            next;
        };
        if ( $in eq q{} ) {
            $in     = $value;
        };
        if ( $valid and not $in =~ /$valid/ ) {
            say 'Sorry, invalid value.';
            say $help;
            next;
        };
        $value  = $in;
        say $value;
        last;
    };
    
    return $value;
}; ## _query


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
    valid:  '^[[:alpha:]]'
-
    key:    user-pass
    query:  What is your password?
    resort: ''
    help: >
        "You may choose to set a password. If so, it must be 3 to 8 
        uppercase letters not including 'q' and end in 'z'. Press 
        return to skip setting a password. NOTE: Accounts without 
        passwords are inherently insecure."
-
    key:    dummy
    query:  Who me, fool?
    resort: ~
-
    key:    tilde
    query:  What's a tilde?
    resort: '~'
    valid:  '^~$'
  


