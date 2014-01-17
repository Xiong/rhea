use Test::More tests => 1;

BEGIN {
    $SIG{__DIE__}   = sub {
        warn @_;
        BAIL_OUT( q[Couldn't use module; can't continue.] );    
        
    };
}   

BEGIN {
use App::Rhea;          # Set up a Minetest server using git
use Cwd;                # Get current working directory = cwd();
use File::Spec;         # Portable OO methods on filenames
use File::Path;         # Create or remove directory trees
}

pass( 'Use modules.' );
diag( "Testing App::Rhea $App::Rhea::VERSION" );
