# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/alternatives.eclass,v 1.18 2013/09/21 01:03:42 ottxor Exp $

# @ECLASS: alternatives.eclass
# @AUTHOR:
# Original author: Alastair Tse <liquidx@gentoo.org> (03 Oct 2003)
# @BLURB: Creates symlink to the latest version of multiple slotted packages.
# @DESCRIPTION:
# When a package is SLOT'ed, very often we need to have a symlink to the
# latest version. However, depending on the order the user has merged them,
# more often than not, the symlink maybe clobbered by the older versions.
#
# This eclass provides a convenience function that needs to be given a
# list of alternatives (descending order of recent-ness) and the symlink.
# It will choose the latest version it can find installed and create
# the desired symlink.
#
# There are two ways to use this eclass. First is by declaring two variables
# $SOURCE and $ALTERNATIVES where $SOURCE is the symlink to be created and
# $ALTERNATIVES is a list of alternatives. Second way is the use the function
# alternatives_makesym() like the example below.
# @EXAMPLE:
# pkg_postinst() {
#     alternatives_makesym "/usr/bin/python" "/usr/bin/python2.3" "/usr/bin/python2.2"
# }
#
# @ECLASS-VARIABLE: SOURCE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The symlink to be created

# @ECLASS-VARIABLE: ALTERNATIVES
# @DEFAULT_UNSET
# @DESCRIPTION:
# The list of alternatives
alternatives_makesym() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	local ALTERNATIVES=""
	local SYMLINK=""
	local alt pref

	# usage: alternatives_makesym <resulting symlink> [alternative targets..]
	# make sure it is in the prefix, allow it already to be in the prefix
	SYMLINK=$(realpath --canonicalize-missing --no-symlinks ${EPREFIX}/${1#${EPREFIX}})
	# this trick removes the trailing / from ${ROOT}
	pref=${ROOT%/}
	shift
	ALTERNATIVES=$@

	# step through given alternatives from first to last
	# and if one exists, link it and finish.
	for alt in ${ALTERNATIVES}; do
		alt=$(realpath --canonicalize-missing --no-symlinks ${EPREFIX}/${alt#${EPREFIX}})
		if [[ -e "${pref}${alt}" ]]; then
			einfo "Linking ${pref}${SYMLINK} -> ${alt}"

			pushd $(dirname ${pref}${SYMLINK}) >/dev/null || die
			rm -f ./${SYMLINK##*/} || die
			ln -s ./${alt##*/} ${SYMLINK##*/}
			popd >/dev/null || die
			
			break
		fi
	done

	# report any errors
	if [[ -n ${ALTERNATIVES} && ! -L ${pref}${SYMLINK} ]]; then
		ewarn "Unable to establish ${pref}${SYMLINK} symlink"
	else
		# Remove dead symlinks
		if [[ -L ${pref}${SYMLINK} && ! -e $(realpath --canonicalize-missing ${pref}${SYMLINK}) ]]; then
			ewarn "Removing dead symlink ${pref}${SYMLINK}"
			rm -f ${pref}${SYMLINK}
		fi
	fi
}

# @FUNCTION: alernatives-pkg_postinst
# @DESCRIPTION:
# The alternatives pkg_postinst, this function will be exported
alternatives_pkg_postinst() {
	if [[ -n "${ALTERNATIVES}" && -n "${SOURCE}" ]]; then
		alternatives_makesym ${SOURCE} ${ALTERNATIVES}
	fi
}

# @FUNCTION: alternatives_pkg_postrm
# @DESCRIPTION:
# The alternatives pkg_postrm, this function will be exported
alternatives_pkg_postrm() {
	if [[ -n "${ALTERNATIVES}" && -n "${SOURCE}" ]]; then
		alternatives_makesym ${SOURCE} ${ALTERNATIVES}
	fi
}

EXPORT_FUNCTIONS pkg_postinst pkg_postrm
