# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtest/gtest-1.6.0.ebuild,v 1.10 2012/07/16 12:17:56 blueness Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
inherit python-any-r1 solidfire-libs

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="http://code.google.com/p/googletest/"
SRC_URI="http://googletest.googlecode.com/files/${MY_P}.zip"

LICENSE="BSD"
KEYWORDS="amd64 ~amd64"

DEPEND="app-arch/unzip
	=sys-devel/gcc-solidfire-4.8.1
	${PYTHON_DEPS}"
RDEPEND=""

PATCHES=( "${FILESDIR}/tags_filter.patch" )

src_configure()
{
	econf               \
		--enable-static \
		--with-pthreads \

	sed -i -e "s|# This library was specified with -dlpreopen.|if [[ \"\${name}\" -eq 'gtest' ]]; then name='${PF}'; fi\n    # This library was specified with -dlpreopen.|" \
		libtool || die

	sed -i -e "s|lib/libgtest.la|lib/${PF}/lib${PF}.la|g"            	  \
		   -e "s|gtest_libs=\"-l\${name}|gtest_libs=\"-l\${name}${PS}|" \
		scripts/gtest-config || die
}

src_test()
{
	emake check || die
}

src_install()
{
	emake DESTDIR="${D}" install-libLTLIBRARIES install-m4dataDATA install-pkgincludeHEADERS install-pkginclude_internalHEADERS
	dobin scripts/gtest-config
	rm -rf ${DP}/share || die
}
