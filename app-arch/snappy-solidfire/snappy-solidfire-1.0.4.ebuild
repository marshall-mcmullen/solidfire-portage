# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="A high-speed compression/decompression library by Google"
HOMEPAGE="https://code.google.com/p/snappy/"
SRC_URI="http://snappy.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"

DEPEND="=sys-devel/gcc-solidfire-4.8.1"
RDEPEND="${DEPEND}"

src_configure()
{
	econf                    \
		-without-gflags		 \
		--disable-gtest
}
