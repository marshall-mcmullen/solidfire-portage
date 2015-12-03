# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gflags/gflags-2.0-r1.ebuild,v 1.1 2014/02/25 00:44:57 vapier Exp $

EAPI=5
inherit solidfire-libs

DESCRIPTION="Google's C++ argument parsing library"
HOMEPAGE="http://code.google.com/p/gflags/"
SRC_URI="http://gflags.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ~amd64"

DEPEND="=sys-devel/gcc-solidfire-4.8.1"
RDEPEND=""

PATCHES="gcc-4.7_string_literals.patch
	flagfile_notexist.patch"

src_install()
{
	default_src_install
	
	# Include dir has all header files duplicated in 'google' dir. Silly Google.
	rm -rf "${DP}/include/google" || die
}
