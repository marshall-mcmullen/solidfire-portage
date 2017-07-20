# Copyright 2017 NetApp, Inc. All rights reserved.

EAPI=5

inherit git-r3
inherit solidfire-libs

DESCRIPTION="WAM tools"
HOMEPAGE="http://www.marvell.com"
EGIT_REPO_URI="https://bitbucket.org/solidfire/marvell-tools"

LICENSE="MIT"
KEYWORDS="~amd64"

ENVD_FILE="05${PF}"
SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/etc/env.d/${ENVD_FILE}" )

S="${S}/tools"

src_compile()
{
    emake -j1
}

src_install()
{
    tools=$(grep "target =" Makefile | sed -e 's|target = ||')
    dobin ${tools} libmvwam.so wam_getlogs.sh

    cat > "${T}/${ENVD_FILE}" <<-EOF
	PATH="/sf/packages/${PF}/bin"
	ROOTPATH="/sf/packages/${PF}/bin"
	EOF
    doenvd "${T}/${ENVD_FILE}"
}
