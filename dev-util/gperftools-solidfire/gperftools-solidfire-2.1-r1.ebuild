# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="http://code.google.com/p/gperftools/"
SRC_URI="http://gperftools.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 amd64"

LIBUNWIND_VERSION="1.1-r4"
DEPEND="=sys-libs/libunwind-solidfire-${LIBUNWIND_VERSION}"
RDEPEND="${DEPEND}"

# tests end up in an infinite loop, even without sandbox
RESTRICT=test

src_configure()
{
	append-cppflags "-I/usr/include/libunwind-${VTAG}-${LIBUNWIND_VERSION}"
	append-ldflags  "-L/usr/lib/libunwind-${VTAG}-${LIBUNWIND_VERSION}"
	
	sed -i -e "s|\-lunwind|\-lunwind-${VTAG}-${LIBUNWIND_VERSION}|g"                      \
		   -e "s|AC_CHECK_LIB(unwind|AC_CHECK_LIB(unwind-${VTAG}-${LIBUNWIND_VERSION}|g"  \
		configure || die

	versionize_src_configure
}

src_install()
{
	versionize_src_install
	
	# Include dir has all header files duplicated in 'google' and 'gperftools' dir. Silly Google.
	rm -rf "${D}/$(dirv include)/google" || die
	doincdir_symlink_self "google"
}
