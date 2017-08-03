# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="SMC IPMICFG"
HOMEPAGE="http://www.supermicro.com"
SMC_PKG_NAME="IPMICFG_${PV%.*}_build.${PV##*.}_InternalUse"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${SMC_PKG_NAME}.zip"
SLOT=0

# License is SuperMicro, specific permission given to NetApp to include this tool as part of our product
LICENSE="SuperMicro"
KEYWORDS="~amd64 amd64"

ENVD_FILE="05${PF}"
SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/etc/env.d/${ENVD_FILE}" )

S=${WORKDIR}/${SMC_PKG_NAME}/Linux/64bit

src_install()
{
	doins ${S}/*

    cat > "${T}/${ENVD_FILE}" <<-EOF
	PATH="/sf/packages/${PF}"
	ROOTPATH="/sf/packages/${PF}"
	EOF
    doenvd "${T}/${ENVD_FILE}"
}
