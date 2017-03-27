# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="The extremely fast LZF compression algorithm"
HOMEPAGE="http://oldhome.schmorp.de/marc/liblzf.html"
SRC_URI="http://bitbucket.org/solidfire/liblzf/get/solidfire/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare()
{
	eautoreconf
}

src_install()
{
	emake install DESTDIR="${D}"
}
