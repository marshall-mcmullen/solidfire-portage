# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="Google's C++ mocking framework"
HOMEPAGE="http://code.google.com/p/googlemock/"
SRC_URI="http://googlemock.googlecode.com/files/${MY_P}.zip"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"

RDEPEND=""
DEPEND="app-arch/unzip
	=dev-cpp/gtest-solidfire-1.6.0-r7
	=sys-devel/gcc-solidfire-4.8.1
	${RDEPEND}"

src_configure()
{
	rm -f ${S}/gmock/{Makefile,configure}* || die
	sed -i -e "/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|" \
		Makefile.in || die 

	sed -i -e "s|gtest-config|gtest-config-solidfire-${GTEST_VERSION}|g" 				 \
		   -e "s|\-lgflags|\-lgflags-solidfire-${GFLAGS_VERSION}|g"						 \
		   -e "s|AC_CHECK_LIB(gflags|AC_CHECK_LIB(gflags-solidfire-${GFLAGS_VERSION}|g"  \
		configure || die

	econf

	sed -i -e "s|# This library was specified with -dlpreopen.|if [[ \"\${name}\" -eq 'gmock' ]]; then name='${PF}'; fi\n    # This library was specified with -dlpreopen.|" \
		libtool || die
	
	sed -i -e "s|lib/libgmock.la|lib/${PF}/lib${PF}.la|g"                    \
		   -e "s|gmock_libs=\"-l\${name}|gmock_libs=\"-l\${name}${PS}|" \
		scripts/gmock-config || die
}

src_install()
{
	emake DESTDIR=${D} install-libLTLIBRARIES install-pkgincludeHEADERS install-pkginclude_internalHEADERS
	dobin ${S}/scripts/gmock-config
}
