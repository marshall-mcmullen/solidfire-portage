# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="Collection of American Megatrend (AMI) tools."
HOMEPAGE="https://ami.com/en/"

# Individual versions of all AMI tools in this package
AFULNX_VERSION="5.09.02.1396"
SCELNX_VERSION="5.03.1106"
YAFU_VERSION="4.16.13"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${MY_PF}.tar.gz -> ${PF}.tar.gz"

# Three way license between American Megatrends and Quanta
LICENSE="AMI/Quanta"
KEYWORDS="~amd64 amd64"

S="${WORKDIR}"
src_install()
{
    doins -r ${S}/${MY_PF}/*
    chmod +x ${DP}/bin/{yafuflash2,afulnx_64,scelnx_64}
	dobinlinks ${DP}/bin/*
}

src_compile()
{ :; }
