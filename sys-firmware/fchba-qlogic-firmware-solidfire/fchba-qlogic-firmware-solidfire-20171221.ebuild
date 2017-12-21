# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="QLogic FC HBA Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
QLOGIC_FIRMWARES="bk011018 hld33424 ql2600_fw ql2700_fw"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="QLogic-SLA"
KEYWORDS="~amd64 amd64"

S="${WORKDIR}"
src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/${MY_PF}/*

	# Install ql firmware files directly into /lib/firmware
	mkdir -p ${D}/lib/firmware
	cp ${S}/${MY_PF}/ql*_fw.bin ${D}/lib/firmware
}

