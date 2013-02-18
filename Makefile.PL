# This -*- perl -*- script writes the Makefile for LWP::Parallel
# $Id: Makefile.PL,v 1.14 2004/02/10 15:19:10 langhein Exp $
use ExtUtils::MakeMaker;

=pod 

I am cutting this out.  If you are on a system without LWP it fails to install, when it
would have succeeded if we just let the PREREQ_PM take effect.  If we suddenly get 
a bunch of failure reports I can put this back in and special-case the situation 
where you don't have LWP at all (because, presumably, you're about to get a recent
enough version in that case, as it will just pull the latest from CPAN).  When I 
was about to write that code, I figured, well, let's just put the minimum required
version of LWP in as per the standard and see if that works for poeple.  So,
good luck with that, file a bug if you disagree with this decision.

print "Checking your version of libwww...";
my $required  = "5.64";
my $supported = "6.04";
my $version;
eval {
    require LWP;
    $version = LWP->Version;
    $version >= $required or die "\nLWP::Parallel only works with versions of libwww $required or greater.\nYou seem to have only version $version installed on your system. If you can\nnot or do not want to upgrade to a later version of libwww you should check\nCPAN for an earlier version of this software that might support it.\n";
    $version <= $supported or warn <<WARNING;

           **** WARNING: Unsupported Version of libwww found! ****

This library only supports libwww up to version $supported. You seem to have
version $version installed, which has not yet been tested by the package author
for compatibility. Some or all tests might fail!

Install at your own risk, or wait until a more recent version of this library
is available.

WARNING

};
if ($@) {
    print " failed\n";
    print <<EOT;
$@
Parallel User Agent uses the standard libwww installation to provide
its basic functionality (i.e. connecting to remote sites and receiving
data). You will have to install a current version (>=$required) of the LWP
package before you can proceed.

The latest version of libwww-perl should always be available from:

     http://www.linpro.no/lwp/

The library is also available from the Comprehensive Perl Archive
Network (CPAN).  Visit <URL:http://www.perl.com/CPAN/> to find a CPAN
site near you.

PS: If you _do_ have the libwww-perl library installed, then this
    script was unable to find it. Either figure out why this happens,
    or go ahead and edit Makefile.PL to disable the version check
    (no, this is not recommended) :-)

EOT
    exit;  # No need to go on
} else {
    if ($version < $supported) { print " ok ($version)\nNote: you can upgrade to $supported (although ParallelUA should work ok)\n"; } 
    else { print " ok\n"; }
}

=cut

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'LWP::Parallel',
    'ABSTRACT' => 'Extension for LWP to allow parallel HTTP and FTP access',
    'DISTNAME'  => 'ParallelUserAgent',
    'VERSION_FROM' => 'lib/LWP/Parallel.pm', # finds $VERSION
    'LICENSE'      => 'perl',
    'AUTHOR'       => ['Marc Langheinrich <marclang@cpan.org>', 'Mike South (maintainer) <msouth@cpan.org>'],
    #
    # automated testing on 5.16.2 gave errors at make test; not able to find
    # LWP::Protocol::http10.  Repeated a reduced version of the
    # test with https and it needed IO::Socket::SSL and LWP::Protocol::https10.  
    # 
    # I don't know any of the actual
    # required version numbers here.  This is a start on 
    # getting the problem fixed, though.
    #
    'PREREQ_PM' => {
        'LWP'                    => 5.64,
        'LWP::Protocol::http10'  => 0,
        'IO::Socket::SSL'        => 0,
        'LWP::Protocol::https10' => 0,
    },
);

package MY;

sub test
{
    q(
test: all
	$(FULLPERL) t/TEST 

);
}


