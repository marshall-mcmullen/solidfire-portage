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
	dolib ${S}/${MY_PF}/libs/*
	dobin ${S}/${MY_PF}/bin/*

	einfo "Versioning libs"
	for lib in ${DP}/lib/*; do
		patchelf --debug --set-soname "$(basename ${lib%%.so}${PS}.so)" "${lib}" || die
		mv --verbose "${lib}" "${lib%%.so}${PS}.so" || die
	done

	# Fix binaries
	einfo "Patching qaucli"
	chmod +x ${DP}/bin/qaucli || die
	patchelf --set-rpath "${PREFIX}/lib:${DP}/lib" "${DP}/bin/qaucli" || die
	for lib in ${DP}/lib/*; do
		patchelf --debug --replace-needed "$(basename ${lib%%${PS}.so}.so)" "$(basename ${lib})" "${DP}/bin/qaucli" || die
	done
	
	# To ensure there was no corruption of the binary caused by patchelf make sure it loads properly
	ldd ${DP}/bin/qaucli || die
	${DP}/bin/qaucli -v || die

	# Expose bin symlinks outside our application specific directory.
	dobinlinks ${DP}/bin/qaucli
}
