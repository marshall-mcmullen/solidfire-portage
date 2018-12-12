# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="Opensource Implementation of WS-Management - Command line utility"
HOMEPAGE="https://openwsman.github.io/"
SRC_URI="https://github.com/Openwsman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test examples static-libs"

CDEPEND="
	net-misc/curl[idn]
	sys-apps/openwsman
	"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	test? ( dev-util/cunit )
	"

src_prepare() {
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with test)
		$(use_with examples)
		)
	autotools-utils_src_configure
}
# TODO patch vconfigure option to work exmaples=yes
