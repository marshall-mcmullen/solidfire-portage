# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="QLogic FC HBA QConvergedConsole Tools."
HOMEPAGE="http://www.qlogic.com"

SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/${MY_PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="QLogic SLA"
KEYWORDS="~amd64 amd64"
RESTRICT="strip"

DEPEND=">=dev-util/patchelf-0.9"

S="${WORKDIR}"
src_install()
{
	# Meld libs so dolib.so behaves with SONAME
	patchelf --debug --set-soname "libqlsdm${PS}.so" "${S}/${MY_PF}/libs/libqlsdm.so" || die
	patchelf --debug --set-soname "libHBAAPI${PS}.so" "${S}/${MY_PF}/libs/libHBAAPI.so" || die

	dolib.so ${S}/${MY_PF}/libs/{libqlsdm,libHBAAPI}.so
	doins -r ${S}/${MY_PF}/*
	chmod +x ${DP}/bin/qaucli
	
	# Set library path and modify previous .so file names for automatic path mapping.
	patchelf --set-rpath "${PREFIX}/lib" "${DP}/bin/qaucli" || die
	patchelf --replace-needed "libHBAAPI.so" "libHBAAPI${PS}.so" "${DP}/bin/qaucli"  || die
	patchelf --replace-needed "libqlsdm.so" "libqlsdm${PS}.so" "${DP}/bin/qaucli" || die
	
	# To ensure there was no corruption of the binary caused by patchelf make sure it loads properly
	${DP}/bin/qaucli -v || die

	# Expose bin symlinks outside our application specific directory.
	dobinlinks ${DP}/bin/*
}
