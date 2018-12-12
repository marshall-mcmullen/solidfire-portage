# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="The extremely fast LZF compression algorithm"
HOMEPAGE="http://oldhome.schmorp.de/marc/liblzf.html"
SRC_URI="http://bitbucket.org/solidfire/liblzf/get/solidfire/${PV}.tar.bz2 -> ${P}.tar.bz2"

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
