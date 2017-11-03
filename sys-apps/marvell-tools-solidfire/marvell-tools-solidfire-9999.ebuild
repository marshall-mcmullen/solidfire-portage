# Copyright 2017 NetApp, Inc. All rights reserved.

EAPI=5

inherit git-r3
inherit solidfire

DESCRIPTION="WAM tools"
HOMEPAGE="http://www.marvell.com"
EGIT_REPO_URI="https://bitbucket.org/solidfire/marvell-tools"

LICENSE="MIT"
KEYWORDS="~amd64"

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
