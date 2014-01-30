use Test::More tests => 1;

BEGIN {
    $SIG{__DIE__}   = sub {
        warn @_;
        BAIL_OUT( q[Couldn't use module; can't continue.] );    
        
    };
}   

BEGIN {
    # Project module
use App::Rhea;          # Set up a Minetest server using git

    # Core modules
use Cwd;                # Get current working directory = cwd();
use File::Spec;         # Portable OO methods on filenames
use File::Path;         # Create or remove directory trees
use File::Temp;         # return name and handle of a temporary file safely

    # CPAN modules
use YAML::XS;           # Perl YAML Serialization using XS and libyaml
use Error::Base;        # Simple structured errors with full backtrace
use Perl6::Form;        # Print very nicely formatted blocks of text
use Test::Trap;         # Trap exit codes, exceptions, output, etc.
use Devel::Comments '###';  # Debug with executable smart comments to logs

}

pass( 'Use modules.' );
diag( "Testing App::Rhea $App::Rhea::VERSION" );
