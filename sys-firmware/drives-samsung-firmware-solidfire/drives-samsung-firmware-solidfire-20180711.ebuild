# Copyright 2018 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="Samsung SSD/NVME Drive Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
SAMSUNG_FIRMWARES="CXV8202Q CXV8501Q DXM9BW4Q
                   EXT1303Q GXT1003Q GXT5003Q
                   GXT5104Q HXT7104Q EDA5202Q
                   EDA5200Q"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/distfiles/${P}.tar.gz"

LICENSE="Samsung-Semiconductor-Letter-Agreement"
KEYWORDS="~amd64 amd64"

src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/*
	dopathlinks "/sf/rtfi/firmware/drives/samsung" "${DP}/lib/firmware/."
}

