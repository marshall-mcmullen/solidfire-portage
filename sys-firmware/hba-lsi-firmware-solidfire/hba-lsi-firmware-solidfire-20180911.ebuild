# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="LSI HBA Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
LSI_FIRMWARES="07.25.00.00 08.37.03.00
               11.65.04.00 16.00.01.00
               20.00.08.00"
LSI_BINARIES="sas2flash sas3flash"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${P}.tar.gz"

LICENSE="NetApp"
KEYWORDS="~amd64 amd64"

src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/*
	dopathlinks "/sf/rtfi/firmware/hba/lsi" "${DP}/lib/firmware/."
}
