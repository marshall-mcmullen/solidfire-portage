# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="SanDisk SSD/NVME Drive Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
SANDISK_FIRMWARES="ZZ39RC23 ZZ39RC43 ZZ39RC93"
SANDISK_BINARIES="scli"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${P}.tar.gz"

LICENSE="Western-Digital-Technologies-Inc-Sandisk-End-User-License-Agreement"
KEYWORDS="~amd64 amd64"

src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/*
	dopathlinks "/sf/rtfi/firmware/drives/sandisk" "${DP}/lib/firmware/."
}
