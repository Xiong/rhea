use strict;
use warnings;
#~ use diagnostics;

use Test::More;
use Cwd;                # Get current working directory = cwd();
use File::Spec;         # Portable OO methods on filenames
use YAML::XS;           # Perl YAML Serialization using XS and libyaml

use App::Rhea;
my $QRTRUE       = $App::Rhea::QRTRUE    ;
my $QRFALSE      = $App::Rhea::QRFALSE   ;

#----------------------------------------------------------------------------#
# dialog.t
#
# Converse with user, prompting and accepting input.
#   This script mocks _query() and _load_dialog(), 
#       which are called by _dialog(). 
#
my $unit        = q{App::Rhea::_dialog};
my $base        = $unit . q{: };

#~ diag(q{&### This test normally generates warnings. ###&});

#----------------------------------------------------------------------------#
# CONSTANTS
my $fixed_test_dir      = 'rheatmp';
my $working_dir         = cwd();
my $rhea_dir            = '.rhea';
my $yaml_fn             = 'test.yaml';
my $href                = {
    hoge    => 42,
    piyo    => 'foo',
    aref    => [ 'bar', 17 ],
};

#----------------------------------------------------------------------------#
# GLOBALS

my $mockin      = {};   # sneak extra args into a mocked sub
my $mockout     = {};   # sneak extra return values out of a mocked sub
my $mockstr     = q{};  # scratch string available for mocking

#----------------------------------------------------------------------------#
# MOCKS
no warnings 'redefine';

local *App::Rhea::_query
= sub {
    $mockout->{_query}{args}     = shift;
    return $mockin->{_query}{return};
}; ## mock _query

local *App::Rhea::_load_dialog
= sub {
    
}; ## mock _query

use warnings;
#----------------------------------------------------------------------------#
# SETUP
my $prove_dir       = cwd();    # save CWD to restore on teardown

#~ # Script redirects STDIN *from* $stdin, which must be reloaded in each case
#~ my $stdin           = qq{hoge\npiyo};       # preloaded string
#~ close STDIN;
#~ open (STDIN, '<', \$stdin);

#----------------------------------------------------------------------------#
# CASES

my @td  = (
    
    {
        -case       => 'mock-query-check-null',
        -work       => 1,
        -code       => q|
            my $value   = App::Rhea::_query();
            return $value;
        |,
        -undef      => 1,           # required to return undef
        -outlike    => $QRFALSE,
        -errlike    => $QRFALSE,
    },
    
    {
        -case       => 'magic-word',
        -work       => 1,
        -argv       => [{
            query       => q{What's the word?},
        }],
        -code       => q|
            undef %$mockin;
            undef %$mockout;
            $mockin->{_query}{return}   = 'Thunderbird';    # return from mock
            my $args    = shift @ARGV;
            my $value   = App::Rhea::_query($args);
            $mockstr    = $mockout->{_query}{args}{query};  # args to mock
            return $value;
        |,
        -need       => 'Thunderbird',
        -mocklike   => words(qw( the word )),
#~         -mockdeep   => $QRFALSE,    # from all mocks!
        -outlike    => $QRFALSE,
        -errlike    => $QRFALSE,
    },
    
    {
        -case       => 'mock-check-dog-red',
        -work       => 1,
        -argv       => [{
            query       => q{What color is your dog?},
            value       => q{blue},
        }],
        -code       => q|
            undef %$mockin;
            undef %$mockout;
            $mockin->{_query}{return}     = 'red',          # return from mock
            my $args    = shift @ARGV;
            my $value   = App::Rhea::_query($args);
            $mockstr    = $mockout->{_query}{args}{query};  # args to mock
            return $value;
        |,
        -need       => 'red',
        -mocklike   => words(qw( color dog )),
        -outlike    => $QRFALSE,
        -errlike    => $QRFALSE,
    },
    
    { -done => 1 }, # # # # # # # # # # # # DONE # # # # # # # # # # # # # # #
    
    
    
    
    
);

#----------------------------------------------------------------------------#
# EXECUTE AND CHECK

# persistent across cases if not cleared
my $tc          ;               # test counter (number of cases)
my @rv          = ();           # normal return value
my $stdout      = q{};          # captured  string
my $stderr      = q{};          # captured  string
my $evalerr     = q{};          # trapped   string
my $OLDOUT      ;               # saved STDOUT fh
my $OLDERR      ;               # saved STDERR fh
my $OLDIN       ;               # saved STDIN  fh

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
    last if $_->{-done};                # done with all cases
    next if not $_->{-work};            # skip the whole case
    $tc++;
    my %t           = %{ $_ };
    my $case        = $base . $t{-case};
    note( "---- $case" );
    subtest $case => sub {
        
        # per-case variables
        my $code        = $t{-code};    # execute this code
        my $args        = $t{-args};    # ... with these args
        my $argv        = $t{-argv};    # ... and/or with this @ARGV
        my $die         = $t{-die};     # must fail
        my $like        = $t{-like};    # normal return value regex supplied
        my $need        = $t{-need};    # exact return value supplied
        my $undef       = $t{-undef};   # undef return value required
        my $deep        = $t{-deep};    # traverse structure (e.g., hashref)
        my $outlike     = $t{-outlike}; # STDOUT regex supplied
        my $errlike     = $t{-errlike}; # STDERR regex supplied
        my $mocklike    = $t{-mocklike};# string sneaked out of mock; regex
        my $mockdeep    = $t{-mockdeep};# hashref sneaked out of mock; deeply
        my $punt        = $t{-punt};    # application-specific checks
                
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
        if ( $argv and ref $argv ) {        # set if okay to deref
            @ARGV       = @$argv;
        }
        
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
        if ( defined $undef ) {
            $diag           = 'return-undef';
            $got            = $rv[0];
            $want           = ! defined $got;
            ok( $want, $diag )
                or note("Got: $got");
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
        if ( defined $mocklike ) {
            $diag           = 'mock-like';
            $got            = $mockstr;
            $want           = $mocklike;
            like( $got, $want, $diag );
        }; 
        if ( defined $mockdeep ) {
            $diag           = 'mock-is-deeply';
            $got            = $mockout;
            $want           = $mockdeep;
            is_deeply( $got, $want, $diag );
        };
        
        # Application-specific!
        if ( defined $punt ) {
            $diag           = 'punt-output';
            $got            = $rv[0]->{output};
            $want           = $punt->{output};
            like( $got, $want, $diag );
            $diag           = 'punt-exit';
            $got            = $rv[0]->{exit};
            $want           = $punt->{exit};
            is( $got, $want, $diag );
        }; 
        
        # Extra-verbose dump optional for test script debug.
        if ( $Verbose >= 1 ) {
            note( 'explain: ', explain \@rv         );
            note( ''                                );
        };
        if ( $Verbose >= 1 ) {
            note( 'explain: ', explain \$mockout    );
            note( ''                                );
        };
        
    }; ## subtest
}; ## for

#----------------------------------------------------------------------------#
# TEARDOWN

chdir $prove_dir;       # restore CWD so temp dir can clean itself up
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
