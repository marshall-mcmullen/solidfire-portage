# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="SMC sum utility"
HOMEPAGE="http://www.supermicro.com"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/sum_${PV%.*}_Linux_x86_64_${PV##*.}.tar.gz"
SLOT=0

# License is SuperMicro, specific permission given to NetApp to include this tool as part of our product
LICENSE="SuperMicro"
KEYWORDS="~amd64 amd64"

ENVD_FILE="05${PF}"
SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/etc/env.d/${ENVD_FILE}" )

src_install()
{
    newins ${S}/sum smc-sum

    cat > "${T}/${ENVD_FILE}" <<-EOF
	PATH="/sf/packages/${PF}"
	ROOTPATH="/sf/packages/${PF}"
	EOF
    doenvd "${T}/${ENVD_FILE}"
}
