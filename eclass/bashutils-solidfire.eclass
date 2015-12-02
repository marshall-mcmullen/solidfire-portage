# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: marshall
# Purpose: 
#

if [[ ${___ECLASS_ONCE_BASHUTILS} != "recur -_+^+_- spank" ]] ; then
	___ECLASS_ONCE_BASHUTILS="recur -_+^+_- spank"

inherit solidfire-libs mercurial

EXPORT_FUNCTIONS src_install

LICENSE="Apache-2.0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 sparc-fbsd x86-fbsd"

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}"

bashutils-solidfire_src_install()
{
	insinto ${PREFIX}/share
	doins ${S}/*

	local bin
	for bin in bashlint ebench etest ibu; do
		[[ -e ${D}/${PREFIX}/share/${bin} ]] && chmod +x ${D}/${PREFIX}/share/${bin}
	done

	# Modify interdependencies between scripts so they can find one another
	for f in $(grep -rl BASHUTILS ${D}); do
		sed -i -e "s|\${BASHUTILS}|${PREFIX}/share|g" ${f} || die
	done
}

fi
