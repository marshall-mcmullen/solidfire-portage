# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="Samsung SSD/NVME Drive Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
SAMSUNG_FIRMWARES="CXV8202Q CXV8501Q DXM9BW4Q
                   EXT1303Q GXT1003Q GXT5003Q
                   GXT5104Q"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="NetApp"
KEYWORDS="~amd64 amd64"

S="${WORKDIR}"
src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/${MY_PF}/*

	doblackduck_metadata \
		usage="Component (Separate Work)" \
		comment="Checking and flashing firmware on Samsung drives" \
		modified="false" \
		commercial="false"
}

