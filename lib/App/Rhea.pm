package App::Rhea;
use 5.014002;   # 5.14.2    # 2012  # pop $arrayref, copy s///r
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules

# CPAN modules

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# GLOBALS

# Compiled regexes
our $QRFALSE        = qr/\A0?\z/            ;
our $QRTRUE         = qr/\A(?!$QRFALSE)/    ;

# git-specific
my $git_name        = 'git';

#----------------------------------------------------------------------------#

#=========# INTERNAL ROUTINE
#
#~     _git( @args );
#       
# Parms     : array of strings
# Returns   : shell exit code
# Output    : passes STDOUT, STDERR untouched
# 
# Pass-through execution of arbitrary git command...
#   ... not otherwise managed.
# 
sub _git {
    my @args    = @_ or ();
#~     my $cmd     = join q{ }, @args;
    
    system $git_name, @args;
    
    my $status  = ($? >> 8);
    
    return $status;
}; ## _git

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





