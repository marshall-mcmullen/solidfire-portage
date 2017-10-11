# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="Toshiba SSD/NVME Drive Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire-libs

# Individual versions of all payloads in this package
TOSHIBA_FIRMWARES="8ENP6101 8ENP7101"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="NetApp"
KEYWORDS="~amd64 amd64"

S="${WORKDIR}"
src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/${MY_PF}/*
}

