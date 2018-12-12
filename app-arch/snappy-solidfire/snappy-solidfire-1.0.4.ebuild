# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="A high-speed compression/decompression library by Google"
HOMEPAGE="https://code.google.com/p/snappy/"
SRC_URI="http://snappy.googlecode.com/files/${UPSTREAM_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure()
{
	econf                    \
		-without-gflags		 \
		--disable-gtest
}
