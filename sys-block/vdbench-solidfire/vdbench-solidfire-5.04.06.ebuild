# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire-libs

DESCRIPTION="Oracle's IO benchmark and stress suite"
HOMEPAGE="http://www.oracle.com/technetwork/server-storage/"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${MY_PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="OTN"
KEYWORDS="~amd64 amd64"

DEPEND=""
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}"
src_install()
{
    doins -r ${S}/${MY_PF}/*
    chmod +x "${DP}"/bin/vdbench
	dobinlinks "${DP}/bin/vdbench"
}

src_compile()
{ :; }
