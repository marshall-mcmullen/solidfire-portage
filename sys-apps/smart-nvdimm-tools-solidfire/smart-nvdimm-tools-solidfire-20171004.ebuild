# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire-libs

DESCRIPTION="SMART NVDIMM Diagnostic Tools"
HOMEPAGE="http://www.smartm.com"
SRC_URI="http://bitbucket.org/solidfire/${MY_PN}/get/release/${PVR}.tar.bz2 -> ${PF}.tar.bz2
         http://bdr-jenkins.eng.solidfire.net/qct/staging/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="SMART NDA"
KEYWORDS="~amd64 amd64"

SOLIDFIRE_EXPORT_PATH="/sf/packages/${PF}/bin"

src_compile()
{
    emake -j1
}

src_install()
{
	echo -e "${D}"
    dobin "smart-nvdimm"
}
