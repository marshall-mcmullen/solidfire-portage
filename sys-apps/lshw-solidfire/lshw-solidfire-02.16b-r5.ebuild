# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit versionize

DESCRIPTION="Hardware Lister"
HOMEPAGE="http://ezix.org/project/wiki/HardwareLister"
MY_P="${MY_PN}-B.${PV/b}"
SRC_URI="http://ezix.org/software/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 amd64"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( 
	"${FILESDIR}/${PV}-gentoo.patch" 
	"${FILESDIR}/disable_scan_partitions.patch"
)

S=${WORKDIR}/${MY_P}

src_compile()
{
	emake all
}

src_install()
{
	versionize_src_install
	rm -rf ${D}/usr/share/lshw ${D}/usr/share/locale || die
}
