#!/usr/bin/env perl
#       rhea.pl
#       = Copyright 2014 Xiong Changnian  <xiong@cpan.org>   =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.014002;   # 5.14.2    # 2012  # pop $arrayref, copy s///r
use strict;
use warnings;
use version; our $VERSION = qv('0.0.0');

# Core module
use lib qw| lib |;

# Project module
use App::Rhea;

## use
#============================================================================#

exit App::Rhea::run(@ARGV);

#============================================================================#
__END__     

=head1 NAME

rhea - Set up a Minetest server using git

=head1 VERSION

This document describes rhea version v0.0.0

=head1 SYNOPSIS

    $ rhea

=head1 DESCRIPTION

=over

I< When ye least expect it, there Rhea will be,   > 
I< and your screams will break your throats. > 
-- Stephen King

=back





=head1 SEE ALSO

L<< App::Rhea|App::Rhea >>

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
