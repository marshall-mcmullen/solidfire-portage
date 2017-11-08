# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="QLogic FC HBA Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
QLOGIC_FIRMWARES="bk011018 hld33424"

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
		comment="Checking and flashing firmware on QLogic FibreChannel HBA" \
		modified="false" \
		commercial="false"
}

