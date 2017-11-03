# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire

DESCRIPTION="Hardware Lister"
HOMEPAGE="http://ezix.org/project/wiki/HardwareLister"
SRC_URI="http://bitbucket.org/solidfire/${MY_PN}/get/solidfire/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 amd64"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_configure()
{
    sed -i -e "s|PREFIX?=/usr|PREFIX=${PREFIX}|"        \
		   -e "s|CXX?=c++|CXX=$(tc-getCXX)|"            \
		   -e "s|CXX=c++|CXX=$(tc-getCXX)|"             \
		   -e "s|LDFLAGS=\(.*\)|LDFLAGS=${LDFLAGS} \1|" \
		{.,core,gui}/Makefile || die "Modifying Makefile failed"
}

src_compile()
{
	emake all
}

src_install()
{
	emake DESTDIR="${D}" PREFIX="${PREFIX}" install
	rm -rf ${D}/share/{lshw,locale} || die
}
