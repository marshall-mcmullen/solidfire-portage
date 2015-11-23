# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: root
# Purpose: 
#
if [[ ${___ECLASS_ONCE_SFDEV} != "recur -_+^+_- spank" ]] ; then
___ECLASS_ONCE_SFDEV="recur -_+^+_- spank"

inherit base autotools eutils

DEPEND="app-portage/gentoolkit"

EXPORT_FUNCTIONS pkg_setup src_install

## FIXME: Need to validate no conflicting slots of packages pulled in.
solidfire-libs_pkg_setup() {
    mkdir -p ${S} || die
}

solidfire-libs_src_install() {
    mkdir -p ${D}/opt/solidfire-libs-${PV}/{include,lib,metadata}
    einfo "Creating opt symlinks for ${RDEPEND} in [/opt/solidfire-libs-${PV}]"
    local deps=( ${RDEPEND} )

    for d in ${deps[@]}; do
         [[ ${d} =~ solidfire ]] || continue

        local name="${d#*/}";              [[ -z ${name} ]] && die
        local base="${name%-solidfire*}";  [[ -z ${base} ]] && die

        [[ -e /usr/include/${name} ]] && dosym "/usr/include/${name}" "/opt/solidfire-libs-${PV}/include/${base}"
        [[ -e /usr/lib/${name} ]]     && dosym "/usr/lib/${name}"     "/opt/solidfire-libs-${PV}/lib/${base}"
    done

	## METADATA ##
	local metadata="${D}/opt/solidfire-libs-${PV}/metadata"
	env > ${metadata}/env.info
	emerge --info =${PF} > ${metadata}/emerge.info
	equery --no-color depgraph --depth 2 =${PF} -l > ${metadata}/depgraph.info
}

fi

