# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="QLogic FC HBA QConvergedConsole Tools."
HOMEPAGE="http://www.qlogic.com"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${MY_PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="QLogic SLA"
KEYWORDS="~amd64 amd64"

DEPEND=">=dev-util/patchelf-0.9.0"

SOLIDFIRE_EXPORT_PATH="/sf/packages/${PF}/bin"

S="${WORKDIR}"
src_install()
{
	# Meld libs so dolib.so behaves with SONAME
	patchelf --debug --set-soname "libqlsdm${PS}.so" "${S}/${MY_PF}/libs/libqlsdm.so"
	patchelf --debug --set-soname "libHBAAPI${PS}.so" "${S}/${MY_PF}/libs/libHBAAPI.so"

	dolib.so ${S}/${MY_PF}/libs/{libqlsdm,libHBAAPI}.so
	doins -r ${S}/${MY_PF}/*
}

src_compile()
{
	true
}

pkg_postinst()
{
	chmod +x "${PREFIX}"/bin/qaucli

	# Heresy is at work here - change lib targets of Qlogic precompiled binary
	patchelf --replace-needed "libHBAAPI.so" "${PREFIX}/lib64/libHBAAPI${PS}.so" "${PREFIX}/bin/qaucli" 
	patchelf --replace-needed "libqlsdm.so" "${PREFIX}/lib64/libqlsdm${PS}.so" "${PREFIX}/bin/qaucli"
}
