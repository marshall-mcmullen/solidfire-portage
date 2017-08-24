# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire-libs

DESCRIPTION="Oracle's IO benchmark and stress suite"
HOMEPAGE="http://www.oracle.com/technetwork/server-storage/"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${MY_PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="OTN"
KEYWORDS="~amd64 amd64"

DEPEND=">=virtual/jdk-1.7"
RDEPEND="${DEPEND}"

ENVD_FILE="05${PF}"
SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/etc" "/etc/env.d" "/etc/env.d/${ENVD_FILE}" )

S="${WORKDIR}"
src_install()
{
    doins -r ${S}/${MY_PF}/*
    chmod +x "${DP}"/bin/vdbench

    cat > "${T}/${ENVD_FILE}" <<-EOF
	PATH="/sf/packages/${PF}/bin"
	ROOTPATH="/sf/packages/${PF}/bin"
	EOF
    doenvd "${T}/${ENVD_FILE}"
}

src_compile()
{
    true
}
