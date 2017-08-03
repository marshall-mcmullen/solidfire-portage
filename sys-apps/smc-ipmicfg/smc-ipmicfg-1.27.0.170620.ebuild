# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="SMC IPMICFG"
HOMEPAGE="http://www.supermicro.com"
SMC_PKG_NAME="IPMICFG_${PV%.*}_build.${PV##*.}_InternalUse"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${SMC_PKG_NAME}.zip"
SLOT=0
RESTRICT="strip"

# License is SuperMicro, specific permission given to NetApp to include this tool as part of our product
LICENSE="SuperMicro"

KEYWORDS="~amd64 amd64"

src_unpack() {
    unpack ${A}
	mkdir -p ${S}
	mv ${SMC_PKG_NAME}/Linux/64bit/* ${S}
}

src_install()
{
    insinto /opt/${P}
	doins ${S}/*
	insinto /opt
	dosym ${P} /opt/${PN}
}
