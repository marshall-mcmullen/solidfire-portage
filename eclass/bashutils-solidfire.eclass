# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: marshall
# Purpose: 
#

if [[ -z ${_BASHUTILS_ECLASS} ]]; then
_BASHUTILS_ECLASS=1

inherit solidfire-libs

EXPORT_FUNCTIONS src_install

LICENSE="Apache-2.0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 sparc-fbsd x86-fbsd"

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}"

SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/usr/local/share/${MY_PF}" )

bashutils-solidfire_src_install()
{
	insinto ${PREFIX}
	doins ${S}/*

	local bin
	for bin in bashlint ebench etest ibu; do
		[[ -e ${DP}/${bin} ]] && chmod +x ${DP}/${bin}
	done

	# Modify interdependencies between scripts so they can find one another
	for f in $(grep -rl BASHUTILS ${D}); do
		sed -i -e "s|\${BASHUTILS}|${PREFIX}|g" ${f} || die
	done

	# Setup backwards compatible symlinks into /usr/local/share/bashutils*
	dosym ${PREFIX} /usr/local/share/${MY_PF}
}

fi
