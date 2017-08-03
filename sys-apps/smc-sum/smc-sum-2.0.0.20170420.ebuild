# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
DESCRIPTION="SMC sum utility"
HOMEPAGE="http://www.supermicro.com"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/sum_${PV%.*}_Linux_x86_64_${PV##*.}.tar.gz"
SLOT=0
RESTRICT="strip"

# License is SuperMicro, specific permission given to NetApp to include this tool as part of our product
LICENSE="SuperMicro"

KEYWORDS="~amd64 amd64"

src_unpack() {
    unpack ${A}
	mv sum_2.0.0_Linux_x86_64 ${S}
}

src_install()
{
    insinto /opt/${P}
	doins -r ${S}/*
	insinto /opt
	dosym ${P} /opt/${PN}
}
