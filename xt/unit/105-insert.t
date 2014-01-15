use strict;
use warnings;

use Test::More;

# Modules standard with wheezy
use DBI 1.616;          # Generic interface to a large number of databases
use DBD::mysql;         # DBI driver for MySQL

use Local::Wicket;
my $QRTRUE       = $Local::Wicket::QRTRUE    ;
my $QRFALSE      = $Local::Wicket::QRFALSE   ;

#----------------------------------------------------------------------------#
# insert.t
#
# Create a test database table and do a test user insert.
#
# NOTE: For script to pass a test configuration must be created manually.
#   $ mysql -u root -p
#   mysql> CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'testpass';
#   mysql> GRANT ALL ON test.* TO 'testuser'@'localhost';
#
#----------------------------------------------------------------------------#
# CONSTANTS

my $username    = 'Joe';                # (game) user to insert
my $password    = 'flimflam';           # temporary password given to user
my $dbname      = 'test';               # name of the wiki's MySQL DB
my $dbuser      = 'testuser';           # same as the wiki's DB user
my $dbpass      = 'testpass';           # DB password for above
my $dbtable     = 'test_table';         # name of the "user" table

#----------------------------------------------------------------------------#
# GLOBALS

my $dbh         ;                       # must keep handle global!

#----------------------------------------------------------------------------#
# CASES

my @td  = (
    {
        -case   => 'null',
        -die    => $QRTRUE,
    },
    
    {
        -case   => 'setup',     # must come first!
        -code   => q[
            note 'Setting up...';
            my $errno       ;
            my $dbhost      = 'localhost';
            my $dsn         = "DBI:mysql:database=$dbname;host=$dbhost";
            $dbh            = DBI->connect( $dsn, $dbuser, $dbpass,
                                { RaiseError => 1 }
                            );
            $dbh->do(qq[DROP TABLE IF EXISTS $dbtable]);
            my $statement   = qq{CREATE TABLE $dbtable}
                            .  q{(}
                            .  q{ user_id INT(10) UNSIGNED }
                            .  q{PRIMARY KEY SERIAL DEFAULT VALUE }
                            .  q{,}
                            .  q{ user_name VARCHAR(255) UNIQUE }
                            .  q{,}
                            .  q{ user_password TINYBLOB NOT NULL }
                            .  q{)}
                            ;
            $dbh->do($statement);
            $errno = $dbh->{'mysql_errno'};
            return $errno if $errno;
            return 0;   # OK
        ],
        -need   => 0,
    },
    
    {
        -case   => 'Joe',
        -args   => [{
            username    => 'Joe',       # OK
            password    => $password,   # 
            dbname      => $dbname,     # 
            dbuser      => $dbuser,     # 
            dbpass      => $dbpass,     # 
            dbtable     => $dbtable,    # 
        }],
        -like   => $QRTRUE,
    },
    
    {
        -case   => 'query select',
        -code   => q[
            my $sth;
            my @rv;
            $sth = $dbh->prepare("SELECT * FROM $dbtable");
            $sth->execute();
            while ( my $ref = $sth->fetchrow_hashref() ) {
                push @rv, "$ref->{'user_id'}, $ref->{'user_name'}";
            }
            $sth->finish();
            return @rv;
        ],
        -like   => words( '1', 'Joe' ),
    },
    
    {
        -case   => 'Suzy',
        -args   => [{
            username    => 'Suzy',      # OK
            password    => $password,   # 
            dbname      => $dbname,     # 
            dbuser      => $dbuser,     # 
            dbpass      => $dbpass,     # 
            dbtable     => $dbtable,    # 
        }],
        -like   => $QRTRUE,
    },
    
    {
        -case   => 'query select',
        -code   => q[
            my $sth;
            my @rv;
            $sth = $dbh->prepare("SELECT * FROM $dbtable");
            $sth->execute();
            while ( my $ref = $sth->fetchrow_hashref() ) {
                push @rv, "$ref->{'user_id'}, $ref->{'user_name'}";
            }
            $sth->finish();
            return @rv;
        ],
        -like   => words( '1', 'Joe', '2', 'Suzy' ),
    },
    
    {
        -case   => 'Evil Freddy',
        -args   => [{
            username    => $username,   # 
            password    => $password,   # 
            dbname      => $dbname,     # 
            dbuser      => 'Freddy',    # BAD
            dbpass      => $dbpass,     # 
            dbtable     => $dbtable,    # 
        }],
        -die    => words(qw/ 70 /),
    },
        
);

#----------------------------------------------------------------------------#
# EXECUTE AND CHECK

my $tc          ;
my $base        = 'Local::Wicket: _insert ';
my $diag        = $base;
my @rv          ;
my $got         ;
my $want        ;

#----------------------------------------------------------------------------#

# Extra-verbose dump optional for test script debug.
my $Verbose     = 0;
#~    $Verbose++;

for (@td) {
    $tc++;
    my %t           = %{ $_ };
    my $case        = $base . $t{-case};
    
    note( "---- $case" );
    subtest $case => sub {
        
        my @args        = eval{ @{ $t{-args} } };
        my $die         = $t{-die};     # must fail
        my $like        = $t{-like};    # regex supplied
        my $need        = $t{-need};    # exact return value supplied
        my $code        = $t{-code};    # execute this code instead
        
        $diag           = 'execute';
        if ($code) {
            @rv             = eval "$code" ;
        }
        else {
            @rv             = eval{ Local::Wicket::_insert(@args) };
        };
        pass( $diag );          # test didn't blow up
        my $err         = $@;
        note($err) if $err;     # did code under test blow up?
        
        if ( $err and not $die ) {
            $diag           = 'eval error';
            fail( $diag );
        };
        
        if    ($die) {
            $diag           = 'should throw';
            $got            = $err;
            $want           = $die;
            like( $got, $want, $diag );
        }
        elsif ($like) {
            $diag           = 'return-like';
            $got            = join qq{\n}, @rv;
            $want           = $like;
            like( $got, $want, $diag );
        } 
        elsif ($need) {
            $diag           = 'return-is';
            $got            = $rv[0];
            $want           = $need;
            is( $got, $want, $diag );
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

$dbh->disconnect();
done_testing($tc);
exit 0;

#============================================================================#

sub words {                         # sloppy match these strings
    my @words   = @_;
    my $regex   = q{};
    
    for (@words) {
        $regex  = $regex . $_ . '.*';
    };
    
    return qr/$regex/is;
};

__END__
