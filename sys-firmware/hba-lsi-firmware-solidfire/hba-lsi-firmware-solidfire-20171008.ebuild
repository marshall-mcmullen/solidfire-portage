# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="LSI HBA Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
LSI_FIRMWARES="07.25.00.00 08.27.03.00 08.31.00.00
               11.65.04.00 13.00.00.00 13.00.57.00
               20.00.08.00"
LSI_BINARIES="sas2flash sas3flash"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="NetApp"
KEYWORDS="~amd64 amd64"

S="${WORKDIR}"
src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/${MY_PF}/*
}

