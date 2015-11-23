# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit versionize mercurial

DESCRIPTION="Collection of bash utilities for simpler and more robust bash programming"
HOMEPAGE="http://solidfire.com"
EHG_REPO_URI="http://hgserve.eng.solidfire.net/hg/bashutils"
EHG_REVISION="0a7c0c38ad70"

LICENSE="Apache-2.0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 sparc-fbsd x86-fbsd"

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}"

src_install()
{
	insinto $(dirv share)
	doins ${S}/*

	# Modify interdependencies between scripts so they can find one another
	for f in $(grep -rl BASHUTILS_PATH ${D}); do
		sed -i -e "s|\${BASHUTILS_PATH}|$(dirv share)|g" ${f} || die
	done

	versionize_src_install
}

pkg_postinst()
{
	versionize_pkg_postinst

	# Create symlinks to the non-VTAG version for compatibility
	einfo "Linking ${DMERGE}/share/${P/-${VTAG}} -> ${DMERGE}/share/${P}"
	ln -sf ${DMERGE}/share/${P} ${DMERGE}/share/${P/-${VTAG}/} || die "Failed to symlink to ${DMERGE}/share/${PN}"
}
