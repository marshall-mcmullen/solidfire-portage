# Copyright 2017 NetApp, Inc. All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="WAM tools"
HOMEPAGE="http://www.marvell.com"
SRC_URI="https://bitbucket.org/solidfire/${MY_PN}/get/solidfire/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="MIT"
KEYWORDS="amd64"

SOLIDFIRE_EXPORT_PATH="/sf/packages/${PF}/bin"

S="${S}/tools"

src_compile()
{
    emake -j1
}

src_install()
{
    tools=$(grep "target =" Makefile | sed -e 's|target = ||')
    dobin ${tools} libmvwam.so wam_getlogs.sh
}
