# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="Triton BIOS and firmware payloads for chassis, ME, PCH, and BMC."
HOMEPAGE="https://www.netapp.com"

# Individual versions of all payloads in this package
BIOS_VERSION="1A04"
ME_VERSION="1A04"
BMC_VERSION="3.16.07"
CPLD_VERSION="1.94-R117"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${PF}.tar.gz -> ${PF}.tar.gz"

SLOT="0"
LICENSE="NetApp"
KEYWORDS="~amd64 amd64"

SF_RTFI_FIRMWARE_PATH="/sf/rtfi/firmware/chassis/QS52B"

S="${WORKDIR}"
src_install()
{
	# Add chassis specific payloads into rtfi/firmware
	insinto ${SF_RTFI_FIRMWARE_PATH}
    doins -r ${S}/*
}

