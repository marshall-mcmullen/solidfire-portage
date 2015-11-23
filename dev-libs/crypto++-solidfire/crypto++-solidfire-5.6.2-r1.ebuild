# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="http://cryptopp.com/"
SRC_URI="http://www.cryptopp.com/cryptopp${PV//.}.zip"

LICENSE="Boost-1.0"
KEYWORDS="~amd64 amd64"

DEPEND="app-arch/unzip
	sys-devel/libtool"
RDEPEND="${DEPEND}"

S=${WORKDIR}

PATCHES=( "${FILESDIR}/makefile-${PV}.patch" )

BUILD_ARGS="INCLUDEDIR=$(dirv include) LIBDIR=$(dirv lib) BINDIR=$(dirv bin) LIBSUFFIX=-${MY_PVR}"

src_compile()
{
	emake -f GNUmakefile ${BUILD_ARGS}
}

src_install()
{
	emake -f GNUmakefile DESTDIR="${D}" ${BUILD_ARGS} install || die
	versionize_src_postinst
}

