# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="http://cryptopp.com/"
SRC_URI="http://www.cryptopp.com/cryptopp${PV//.}.zip"

LICENSE="Boost-1.0"
KEYWORDS="~amd64 amd64"

DEPEND="app-arch/unzip
	=sys-devel/gcc-solidfire-4.8.1
	sys-devel/libtool"
RDEPEND="${DEPEND}"

S=${WORKDIR}

PATCHES="makefile-${PV}.patch"

BUILD_ARGS="INCLUDEDIR=${PREFIX}/include LIBDIR=${PREFIX}/lib BINDIR=${PREFIX}/bin LIBSUFFIX=${PS}"

src_compile()
{
	emake -f GNUmakefile ${BUILD_ARGS}
}

src_install()
{
	emake -f GNUmakefile DESTDIR="${D}" ${BUILD_ARGS} install || die
}

