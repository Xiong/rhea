use strict;
use warnings;
#~ use diagnostics;

use Test::More;

use App::Rhea;
my $QRTRUE       = $App::Rhea::QRTRUE    ;
my $QRFALSE      = $App::Rhea::QRFALSE   ;

#----------------------------------------------------------------------------#
# git.t
#
# Pass-through execution of arbitrary git command.
#
my $unit        = q{App::Rhea::_git};
my $base        = $unit . q{: };

diag(q{&### This test normally generates much console output. ###&});

#----------------------------------------------------------------------------#
# CONSTANTS

#----------------------------------------------------------------------------#
# GLOBALS


#----------------------------------------------------------------------------#
# CASES

my @td  = (
    
    {
        -case       => 'no args',       # emits usage; considered an error
        -args       => [
                    ],
        -need       => 1,               # shell exit
    },
    
    {
        -case       => 'setup',
        -code       => q{
                        system(qw| mkdir rheatmp    |);
                        chdir 'rheatmp'               ;
                        system(qw| git init         |);
                    },
        -need       => 0,               # shell exit
    },
    
    {
        -case       => 'status',
        -args       => [
                        'status',
                    ],
        -need       => 0,               # shell exit
    },
    
    {
        -case       => 'version',
        -args       => [
                        '--version',
                    ],
        -need       => 0,               # shell exit
    },
    
    
);

#----------------------------------------------------------------------------#
# EXECUTE AND CHECK

# persistent across cases if not cleared
my $tc          ;               # test counter (number of cases)
my @rv          = ();           # normal return value
my $stdout      = q{};          # captured string
my $stderr      = q{};          # captured string
my $evalerr     = q{};          # trapped  string
my $OLDOUT      ;               # saved STDOUT fh
my $OLDERR      ;               # saved STDERR fh

# scratch variables
my @args        ;
my $got         ;
my $want        ;
my $diag        = $base;

#----------------------------------------------------------------------------#

# Extra-verbose dump optional for test script debug.
my $Verbose     = 0;
#~    $Verbose++;

for (@td) {
    next if $_->{-skip};          # skip the entire case
    last if $_->{-done};          # done with all cases
    $tc++;
    my %t           = %{ $_ };
    my $case        = $base . $t{-case};
    note( "---- $case" );
    subtest $case => sub {
        
        # per-case variables
        my $code        = $t{-code};    # execute this code
        my $args        = $t{-args};    # ... with these args
        my $die         = $t{-die};     # must fail
        my $like        = $t{-like};    # normal return value regex supplied
        my $need        = $t{-need};    # exact return value supplied
        my $deep        = $t{-deep};    # traverse structure (e.g., hashref)
        my $outlike     = $t{-outlike}; # STDOUT regex supplied
        my $errlike     = $t{-errlike}; # STDERR regex supplied
                
        # set up code under test
        if ( not $code ) {
            $code       = $unit;            # "sticky"
        };
        if ( $args and ref $args ) {        # concatenate if okay to deref
            @args       = @$args;
            $code       .= q{(@args)};
        }
        else {
            @args       = ();               # otherwise clear global
        };
        
        # test execution
        if ( $code ) {
            $diag           = 'execute';
            suppose( $code );               # this script gimmick
            pass( $diag );                  # gimmick didn't fatal
            note($evalerr) if $evalerr;     # did code under test fatal?
        };
        
        # conditional checks
        if ( $evalerr and not defined $die ) {
            $diag           = 'eval error';
            fail( $diag );
        };
        if ( defined $die ) {
            $diag           = 'should throw';
            $got            = $evalerr;
            $want           = $die;
            like( $got, $want, $diag );
        };
        if ( defined $like ) {
            $diag           = 'return-like';
            $got            = join qq{\n}, @rv;
            $want           = $like;
            like( $got, $want, $diag );
        }; 
        if ( defined $need ) {
            $diag           = 'return-is';
            $got            = $rv[0];
            $want           = $need;
            is( $got, $want, $diag );
        };
        if ( defined $deep ) {
            $diag           = 'return-is-deeply';
            $got            = $rv[0];
            $want           = $deep;
            is_deeply( $got, $want, $diag );
        };
        if ( defined $outlike ) {
            $diag           = 'stdout-like';
            $got            = $stdout;
            $want           = $outlike;
            like( $got, $want, $diag );
        }; 
        if ( defined $errlike ) {
            $diag           = 'stderr-like';
            $got            = $stderr;
            $want           = $errlike;
            like( $got, $want, $diag );
        }; 
        
        # Extra-verbose dump optional for test script debug.
        if ( $Verbose >= 1 ) {
            note( 'explain: ', explain \@rv     );
            note( ''                            );
        };
        
    }; ## subtest
}; ## for

#----------------------------------------------------------------------------#
# TEARDOWN

done_testing($tc);
exit 0;

#============================================================================#

sub suppose {
    my $code    =  shift;
    
    # clear before execution
    @rv          = ();           # normal return value
    $stdout      = q{};          # captured string
    $stderr      = q{};          # captured string
    $evalerr     = q{};          # trapped  string
    
    # capture ON
    open (my $OLDOUT, '>&', STDOUT);
        close STDOUT;
        open (STDOUT, '>', \$stdout);
    open (my $OLDERR, '>&', STDERR);
        close STDERR;
        open (STDERR, '>', \$stderr);
    
    # execute
    @rv         = eval "$code";
    
    # stash @!
    $evalerr    = $@;
    
    # capture OFF
    open (STDOUT, '>&', $OLDOUT);
    open (STDERR, '>&', $OLDERR);
    
    return @rv;
};

sub words {                         # sloppy match these strings
    my @words   = @_;
    my $regex   = q{};
    
    for (@words) {
        $regex  = $regex . $_ . '.*';
    };
    
    return qr/$regex/is;
};

__END__
