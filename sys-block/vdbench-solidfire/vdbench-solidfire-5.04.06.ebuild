# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Oracle's IO benchmark and stress suite"
HOMEPAGE="http://www.oracle.com/technetwork/server-storage/"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${UPSTREAM_P}.tar.gz"

LICENSE="OTN"
KEYWORDS="~amd64 amd64"

DEPEND=""
RDEPEND=">=virtual/jre-1.7"

RESTRICT="splitdebug"

src_install()
{
	doins -r ${S}/*
    chmod +x "${DP}"/bin/vdbench
	dobinlinks "${DP}/bin/vdbench"
}

src_compile()
{ :; }
