

# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Collection of bash utilities for simpler and more robust bash programming"
HOMEPAGE="https://bitbucket.org/solidfire/bashutils"
SRC_URI="https://bitbucket.org/solidfire/${UPSTREAM_PN}/get/${UPSTREAM_P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Apache-2.0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 sparc-fbsd x86-fbsd"

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}"

SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/usr/local/share/${UPSTREAM_P}" )

src_install()
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
    dosym ${PREFIX} /usr/local/share/${UPSTREAM_P}
}
