# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Sedutil-cli OPAL Security Tool"
HOMEPAGE="https://github.com/Drive-Trust-Alliance/sedutil"
SRC_URI="https://github.com/Drive-Trust-Alliance/sedutil/archive/${PVR}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 amd64"

DEPEND="sys-devel/autoconf"

src_configure()
{
	aclocal
	autoreconf --install
	./configure
}

src_compile()
{
	emake -j1
}

src_install()
{
    dobin "sedutil-cli"
	
    # Expose bin symlinks outside our application specific directory
    dobinlinks "${DP}"/bin/*
}
