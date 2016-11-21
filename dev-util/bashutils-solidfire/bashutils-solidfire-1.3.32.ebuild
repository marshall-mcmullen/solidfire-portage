# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="Collection of bash utilities for simpler and more robust bash programming"
HOMEPAGE="https://bitbucket.org/solidfire/bashutils"
SRC_URI="https://bitbucket.org/solidfire/${MY_PN}/get/${MY_PN}-${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="Apache-2.0"
KEYWORDS="amd64"

DEPEND="net-misc/curl
        app-misc/jq
        sys-apps/lsb-release"

RDEPEND="${DEPEND}"

SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/usr/local/share/${MY_PF}" )

src_install()
{
    DESTDIR=${D}/sf/packages/${P} PV=${PV} ${S}/.forge/install || die

    # Setup backwards compatible symlinks into /usr/local/share/bashutils*
    mkdir -p ${D}/usr/local/share/
    ln -sf /sf/packages/${PF} ${D}/usr/local/share/${MY_PN}-${PV} || die
}

src_compile()
{
    true
}
