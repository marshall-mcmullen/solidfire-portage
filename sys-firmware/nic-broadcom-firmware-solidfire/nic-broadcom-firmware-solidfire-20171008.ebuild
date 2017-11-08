# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="Broadcom NIC Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
BROADCOM_FIRMWARES="NF92Y_LN_7.10.18"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="NetApp"
KEYWORDS="~amd64 amd64"

S="${WORKDIR}"
src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/${MY_PF}/*
	chmod +x ${DP}/lib/firmware/*.BIN

	doblackduck_metadata \
		usage="Component (Separate Work)" \
		comment="Checking and flashing firmware on Broadcom NICs" \
		modified="false" \
		commercial="false"
}

