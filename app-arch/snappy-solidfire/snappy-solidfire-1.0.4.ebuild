# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="A high-speed compression/decompression library by Google"
HOMEPAGE="https://code.google.com/p/snappy/"
SRC_URI="http://snappy.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure()
{
	versionize_src_configure \
		--without-gflags     \
		--disable-gtest
}
