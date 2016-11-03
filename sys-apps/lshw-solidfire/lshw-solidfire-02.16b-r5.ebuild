# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="Hardware Lister"
HOMEPAGE="http://ezix.org/project/wiki/HardwareLister"
MY_P="${MY_PN}-B.${PV/b}"
SRC_URI="http://ezix.org/software/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 amd64"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES="disable_scan_partitions.patch"

S=${WORKDIR}/${MY_P}

src_configure()
{
    sed -i -e "s|PREFIX?=/usr|PREFIX=${PREFIX}|"        \
		   -e "s|LDFLAGS=\(.*\)|LDFLAGS=${LDFLAGS} \1|" \
		src/Makefile || die "Modifying Makefile failed"

    sed -i "s|CXX=c++|CXX=${CXX}|" src/core/Makefile ||
        die "Modifying CXX failed"
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
