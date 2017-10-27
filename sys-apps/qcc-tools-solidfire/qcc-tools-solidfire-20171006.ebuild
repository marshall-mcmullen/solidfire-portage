# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="QLogic FC HBA QConvergedConsole Tools."
HOMEPAGE="http://www.qlogic.com"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${MY_PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="QLogic SLA"
KEYWORDS="~amd64 amd64"

DEPEND=">=dev-util/patchelf-0.9"

S="${WORKDIR}"
src_install()
{
	# Meld libs so dolib.so behaves with SONAME
	patchelf --debug --set-soname "libqlsdm${PS}.so" "${S}/${MY_PF}/libs/libqlsdm.so" || die
	patchelf --debug --set-soname "libHBAAPI${PS}.so" "${S}/${MY_PF}/libs/libHBAAPI.so" || die

	dolib.so ${S}/${MY_PF}/libs/{libqlsdm,libHBAAPI}.so
	doins -r ${S}/${MY_PF}/*
	chmod +x "${DP}/bin/qaucli"
}

pkg_postinst()
{
	# Set library path and modify previous .so file names for automatic path mapping.
	# Note: All libs must be in their final resting place before attempting --replace-needed
	# to prevent binary corruption.
	patchelf --set-rpath "${PREFIX}/lib" "${PREFIX}/bin/qaucli"
	patchelf --replace-needed "libHBAAPI.so" "libHBAAPI${PS}.so" "${PREFIX}/bin/qaucli"  || die
	patchelf --replace-needed "libqlsdm.so" "libqlsdm${PS}.so" "${PREFIX}/bin/qaucli" || die

	dobinlinks ${DP}/bin/*
}
