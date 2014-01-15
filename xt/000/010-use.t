use Test::More tests => 1;

BEGIN {
    $SIG{__DIE__}   = sub {
        warn @_;
        BAIL_OUT( q[Couldn't use module; can't continue.] );    
        
    };
}   

BEGIN {
use App::Rhea;          # Set up a Minetest server using git
use Git;                # Perl interface to the Git version control system
}

pass( 'Use modules.' );
diag( "Testing App::Rhea $App::Rhea::VERSION" );
