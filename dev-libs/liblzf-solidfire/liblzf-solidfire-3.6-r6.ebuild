# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-r3 solidfire-libs

DESCRIPTION="The extremely fast LZF compression algorithm"
HOMEPAGE="http://oldhome.schmorp.de/marc/liblzf.html"
EGIT_REPO_URI="https://bitbucket.org/solidfire/liblzf.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
EGIT_COMMIT="solidfire/${PVR}"

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
