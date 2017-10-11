# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="SMART NVRAM Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire-libs

# Individual versions of all payloads in this package
SMART_FIRMWARE="10.07.v24.r23766"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="NetApp"
KEYWORDS="~amd64 amd64"

S="${WORKDIR}"
src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/${MY_PF}/*
}

