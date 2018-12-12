# Copyright 2018 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="Radian NVRAM Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
RADIAN_FIRMWARE="0ceb37ac 0ceb37ad ae34b8cc bce8c1ac"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${P}.tar.gz"

LICENSE="NetApp"
KEYWORDS="~amd64 amd64"

src_install()
{
    # Add chassis specific payloads into /sf/package/../lib/firmware/
    dofirmware -r ${S}/*
	dopathlinks "/sf/rtfi/firmware/nvram/radian" "${DP}/lib/firmware/."
}

