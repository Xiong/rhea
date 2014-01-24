package App::Rhea;
use 5.014002;   # 5.14.2    # 2012  # pop $arrayref, copy s///r
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
use Cwd;                # Get current working directory = cwd();

# CPAN modules

# Alternate uses
use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# GLOBALS

# Constants
my $rhea_token      = q{%# };
my $fixed_test_dir  = q{rheatmp};
my $shrd            = q{ 2>&1};         # bash shell redirect

# Compiled regexes
our $QRFALSE        = qr/\A0?\z/            ;
our $QRTRUE         = qr/\A(?!$QRFALSE)/    ;

# git-specific
my $git_name        = q{git};

# Scratch
my $CWD             ;
$CWD                = cwd();

#----------------------------------------------------------------------------#

#=========# INTERNAL ROUTINE
#
#~     _git_system( @args );
#       
# Parms     : array of strings
# Returns   : shell exit code
# Output    : passes STDOUT, STDERR untouched
# 
# Pass-through execution of arbitrary git command...
#   ... not otherwise managed.
#   This is the mode suitable for interactive commands.
# We do not get any output from the command; the user sees it directly. 
# 
sub _git_system {
    my @args    = @_ or ();
#~     my $cmd     = join q{ }, @args;
    
    system $git_name, @args;
    
    my $status  = ($? >> 8);
    
    return $status;
}; ## _git_system

#=========# INTERNAL ROUTINE
#
#~     _git( @args );
#       
# Parms     : array of strings
# Returns   : 
# Output    : STDOUT, STDERR silenced
# 
# Execution of arbitrary git command...
#   ... with STDOUT, STDERR captured.
# 
sub _git {
    my @args    = @_ or ();
    my $cmd     = join q{ }, $git_name, @args, $shrd;
    
    my $output  = `$cmd`;
    my $status  = ($? >> 8);
    
    return {
        output  => $output,     # STDOUT . STDERR
        exit    => $status,     # shell exit
    };
}; ## _git

#=========# TEST ROUTINE
#
#~     _setup($test_dir);      # set up a test repo and some subs
#       
# Rhea operates on nested git repositories.
# These are too much to set up in each test script.
# 
# If $test_dir is passed in then that will be the exact name of the dir
#   and it will be created in the current working dir
#   and it WILL NOT be cleaned up on exit!
# This should not be done in production for the superproject 
#   but may be done for its subs since File::Temp will force rm the super.
# 
# If called with no args then a dir will be created using File::Temp
#   ... somewhere... with some name...
#   and it WILL be cleaned up on exit. 
# 
# Either way, a 'git init' will be executed in the new dir.
# 
# Returns   : Name of test dir actually created
# 
sub _setup {
    my $test_dir    = shift;
    my $cleanup     ;
    my $template    = 'rheatmpXXXX';
    my $cmd         ;
    my $rv          ;
    my $parent      = cwd();
    
    # Make the test dir.
    if (not $test_dir) {                # then gotta make one up
        $cleanup        = 1;
        
    }
    else {
        $cleanup        = 0;
        `mkdir $test_dir $shrd`;        # silence and discard output
        if ($?) { die "Failed to mkdir $test_dir \n$?" };
    };
    
    # Initialize a git repo here.
    chdir $test_dir
        or die "Failed to chdir $test_dir";
    $rv = _git('init');
    chdir $parent;
    
    return $test_dir;
}; ## _setup

#=========# INTERNAL ROUTINE
#
#~     _do_();     # short
#       
# ____
# 
sub _do_ {
    
    
    
}; ## _do_



## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

App::Rhea - Set up a Minetest server using git

=head1 VERSION

This document describes App::Rhea version v0.0.0

=head1 SYNOPSIS

    exit App::Rhea::run(@ARGV);

=head1 DESCRIPTION

No user-serviceable parts in here. You want B< rhea.pl >.

=head1 METHODS 

=head2 new()

=head1 ACCSESSORS

Object-oriented accessor methods are provided for each parameter and result. 
They all do just what you'd expect. 

    $self               = $self->put_attr($string);
    $string             = $self->get_attr();

=head1 SEE ALSO

L<< Some::Module|Some::Module >>

=head1 INSTALLATION

This module is installed using L<< Module::Build|Module::Build >>. 

=head1 DIAGNOSTICS

=over

=item C<< some error message >>

Some explanation. 

=back

=head1 CONFIGURATION AND ENVIRONMENT

None. 

=head1 DEPENDENCIES

There are no non-core dependencies. 

=begin html

<!--

=end html

L<< version|version >> 0.99 E<10> E<8> E<9>
Perl extension for Version Objects

=begin html

-->

<DL>

<DT>    <a href="http://search.cpan.org/perldoc?version" 
            class="podlinkpod">version</a> 0.99 
<DD>    Perl extension for Version Objects

</DL>

=end html

This module should work with any version of perl 5.14.2 and up. 

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

This is an early release. Reports and suggestions will be warmly welcomed. 

Please report any issues to: 
L<https://github.com/Xiong/rhea/issues>.

=head1 DEVELOPMENT

This project is hosted on GitHub at: 
L<https://github.com/Xiong/rhea>. 

=head1 THANKS

Somebody helped!

=head1 AUTHOR

Xiong Changnian C<< <xiong@cpan.org> >>

=head1 LICENSE

Copyright (C) 2014 
Xiong Changnian C<< <xiong@cpan.org> >>

This library and its contents are released under Artistic License 2.0:

L<http://www.opensource.org/licenses/artistic-license-2.0.php>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_attr

=head2 get_attr

=end   fool_pod_coverage

=cut





