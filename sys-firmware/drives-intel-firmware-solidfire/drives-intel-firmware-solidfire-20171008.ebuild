# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="Intel SSD/NVME Drive Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
INTEL_FIRMWARES="4PC10362 D210370"
INTEL_BINARIES="ConfigurationManager_Linux64"

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
		comment="Checking and flashing firmware on Intel drives" \
		modified="false" \
		commercial="false"
}

