# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="Triton BIOS and firmware payloads for chassis, ME, PCH, and BMC."
HOMEPAGE="https://www.netapp.com"

inherit solidfire

# Individual versions of all payloads in this package
BIOS_VERSION="3A01"
ME_VERSION="3A01"
BMC_VERSION="3.47.07"
CPLD_VERSION="1.94-R117"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="NetApp"
KEYWORDS="~amd64 amd64"

S="${WORKDIR}"
src_install()
{
	# Add chassis specific payloads into /sf/package/../lib/firmware/
	dofirmware -r ${S}/${MY_PF}/*
}

