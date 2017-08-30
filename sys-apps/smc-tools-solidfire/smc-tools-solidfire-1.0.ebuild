# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="Collection of SuperMicro tools for SuperMicro platforms only."
HOMEPAGE="http://www.supermicro.com"
SMC_PKG_NAME="IPMICFG_1.27.0_build.170620_InternalUse"
SUM_PKG_DATE="20170420"
SUM_PKG_NAME="sum_2.0.0_Linux_x86_64_${SUM_PKG_DATE}"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${SMC_PKG_NAME}.zip
         http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${SUM_PKG_NAME}.tar.gz"
SLOT=0
# License is SuperMicro, specific permission given to NetApp to include this tool as part of our product
LICENSE="SuperMicro"
KEYWORDS="~amd64 amd64"

SOLIDFIRE_EXPORT_PATH="/sf/packages/${PF}"

# We don't need or want solidfire-libs package unpack magic (munging) in this case
S="${WORKDIR}"
src_unpack()
{
    default_src_unpack
}

src_install()
{
    # Install all files from both packages
    doins -r ${S}/${SMC_PKG_NAME}/Linux/64bit/*
    doins -r ${S}/${SUM_PKG_NAME%%_${SUM_PKG_DATE}}/*

    # Rename the binaries to have more package specific and consistent naming
    mv --verbose "${DP}/sum" "${DP}/smc-sum" || die
    mv --verbose "${DP}/IPMICFG-Linux.x86_64" "${DP}/smc-ipmicfg" || die
    chmod +x "${DP}"/{smc-sum,smc-ipmicfg}   || die

    # Remove some files we don't care about
    rm --verbose "${DP}"/{SUM_UserGuide.pdf,ReleaseNote.txt} || die
}
