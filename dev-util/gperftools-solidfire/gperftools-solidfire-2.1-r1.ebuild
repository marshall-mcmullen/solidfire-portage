# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="http://code.google.com/p/gperftools/"
SRC_URI="http://gperftools.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 amd64"

DEPEND="=sys-devel/gcc-solidfire-4.8.1
	=sys-libs/libunwind-solidfire-1.1.1-r1"
RDEPEND="${DEPEND}"

# tests end up in an infinite loop, even without sandbox
RESTRICT=test

src_configure()
{
	sed -i -e "s|\-lunwind|\-lunwind-solidfire-${LIBUNWIND_VERSION}|g"                      \
		   -e "s|AC_CHECK_LIB(unwind|AC_CHECK_LIB(unwind-solidfire-${LIBUNWIND_VERSION}|g"  \
		configure || die
	
	econf
}
