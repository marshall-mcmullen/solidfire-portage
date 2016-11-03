# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="The extremely fast LZF compression algorithm"
HOMEPAGE="http://oldhome.schmorp.de/marc/liblzf.html"
SRC_URI="http://dist.schmorp.de/liblzf/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare()
{
	sed -i -e 's/\(\$([a-z]*dir)\)/$(DESTDIR)\1/' Makefile.in || die "sed failed"
}
