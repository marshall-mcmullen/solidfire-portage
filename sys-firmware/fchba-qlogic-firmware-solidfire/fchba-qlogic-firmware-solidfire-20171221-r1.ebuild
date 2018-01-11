# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="QLogic FC HBA Firmware"
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
QLOGIC_FIRMWARES="bk011018 hld33424 ql2600_fw ql2700_fw"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="QLogic-SLA"
KEYWORDS="~amd64 amd64"

S="${WORKDIR}"
src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/${MY_P}/*

	# Install ql firmware symlinks into /lib/firmware
	dopathlinks_lstrip "/lib/firmware" "${DP}/lib/firmware/" ${DP}/lib/firmware/ql*_fw.bin
	dopathlinks "/sf/rtfi/firmware/fchba/qlogic" "${DP}/lib/firmware"
}

