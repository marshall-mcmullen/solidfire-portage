# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="SMART NVDIMM Diagnostic Tools"
HOMEPAGE="http://www.smartm.com"
SRC_URI="http://bitbucket.org/solidfire/${MY_PN}/get/release/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="SMART-NDA"
KEYWORDS="~amd64 amd64"

src_compile()
{
    emake nvdimm -j1
}

src_install()
{
    dobin "smart-nvdimm"
	dobinlinks "${DP}"/bin/*
}
