# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="http://cryptopp.com/"
SRC_URI="http://www.cryptopp.com/cryptopp${PV//.}.zip"

LICENSE="Boost-1.0"
KEYWORDS="~amd64 amd64"

DEPEND="app-arch/unzip
	sys-devel/libtool"
RDEPEND="${DEPEND}"

S=${WORKDIR}

PATCHES="makefile-${PV}.patch"

BUILD_PATHS="DESTDIR=${D} INCLUDEDIR=${PREFIX}/include LIBDIR=${PREFIX}/lib BINDIR=${PREFIX}/bin LIBSUFFIX=${PS} LIBTOOL=./libtool"

src_prepare()
{
	# Generate our own libtool script for building.
	cat <<-EOF > configure.ac
	AC_INIT(lt, 0)
	AM_INIT_AUTOMAKE
	AC_PROG_CXX
	LT_INIT
	AC_CONFIG_FILES(Makefile)
	AC_OUTPUT
	EOF
	touch NEWS README AUTHORS ChangeLog Makefile.am

	solidfire_src_prepare
	eautoreconf
}

src_compile()
{
    # higher optimizations cause problems
    replace-flags -O? -O1
    filter-flags -fomit-frame-pointer

	# Doesn't compile with C++11
	filter-flags -std=c++11
	
	# Add some package specific flags. In particular, needs -fPIC enabled to compile properly.
	append-cxxflags -DNDEBUG -g -fPIC

	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" ${BUILD_PATHS}
}

src_test()
{
	# ensure that all test vectors have Unix line endings
	local file
	for file in TestVectors/* ; do
		edos2unix ${file}
	done

	if ! emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" test ; then
		eerror "Crypto++ self-tests failed."
		eerror "Try to remove some optimization flags and reemerge Crypto++."
		die "emake test failed"
	fi
}

src_install()
{
	emake ${BUILD_PATHS} install
}
