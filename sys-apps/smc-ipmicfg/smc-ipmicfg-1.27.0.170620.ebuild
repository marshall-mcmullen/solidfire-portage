# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="SMC IPMICFG"
HOMEPAGE="http://www.supermicro.com"
SMC_PKG_NAME="IPMICFG_${PV%.*}_build.${PV##*.}_InternalUse"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${SMC_PKG_NAME}.zip"
SLOT=0

# License is SuperMicro, specific permission given to NetApp to include this tool as part of our product
LICENSE="SuperMicro"

KEYWORDS="~amd64 amd64"

S=${WORKDIR}/${SMC_PKG_NAME}/Linux/64bit

src_install()
{
    insinto /opt/${P}
    doins ${S}/*
    insinto /opt
    dosym ${P} /opt/${PN}
}
