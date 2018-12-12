# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Collection of bash utilities for simpler and more robust bash programming"
HOMEPAGE="https://bitbucket.org/solidfire/bashutils"
SRC_URI="https://bitbucket.org/solidfire/${UPSTREAM_PN}/get/${UPSTREAM_P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Apache-2.0"
KEYWORDS="amd64"

DEPEND="net-misc/curl
        app-misc/jq
        sys-apps/lsb-release"

RDEPEND="${DEPEND}"

SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/usr/local/share/${UPSTREAM_P}" )

src_install()
{
    DESTDIR=${D}/sf/packages/${P} PV=${PV} ${S}/.forge/install || die

    # Setup backwards compatible symlinks into /usr/local/share/bashutils*
    mkdir -p ${D}/usr/local/share/
    ln -sf /sf/packages/${PF} ${D}/usr/local/share/${UPSTREAM_PN}-${PV} || die
}
