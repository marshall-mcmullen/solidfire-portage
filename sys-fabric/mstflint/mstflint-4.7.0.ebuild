# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Mellanox firmware burning and diagnostics tools"
HOMEPAGE="https://github.com/Mellanox/mstflint"
SRC_URI="https://github.com/Mellanox/mstflint/releases/download/v${PV}-1/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT=0
IUSE="infiniband ssl libxml2"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

src_configure() {
    econf \
		$(use_enable infiniband inband) \
		$(use_enable ssl openssl) \
		$(use_enable libxml2 xml2)
}

src_compile() {
    emake -j5
}
