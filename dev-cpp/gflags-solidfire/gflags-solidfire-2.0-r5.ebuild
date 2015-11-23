# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gflags/gflags-2.0-r1.ebuild,v 1.1 2014/02/25 00:44:57 vapier Exp $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="Google's C++ argument parsing library"
HOMEPAGE="http://code.google.com/p/gflags/"
SRC_URI="http://gflags.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ~amd64"
PATCHES=( 
	"${FILESDIR}/gcc-4.7_string_literals.patch"
	"${FILESDIR}/flagfile_notexist.patch" 
)

src_install()
{
	versionize_src_install
	
	# Include dir has all header files duplicated in 'google' dir. Silly Google.
	rm -rf "${D}/usr/include/${PF}/google" || die
	doincdir_symlink_self "google"
}
