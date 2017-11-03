# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire

DESCRIPTION="Collection of bash utilities for simpler and more robust bash programming"
HOMEPAGE="https://bitbucket.org/solidfire/bashutils"
SRC_URI="https://bitbucket.org/solidfire/${MY_PN}/get/${MY_PN}-${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="Apache-2.0"
KEYWORDS="amd64"

DEPEND="
        app-admin/sudo
        app-arch/cpio
        || ( app-arch/lbzip2 app-arch/bzip2 )
        || ( app-arch/pigz app-arch/gzip )
        app-arch/xz-utils
        app-cdr/cdrtools
        app-misc/jq
        dev-util/dialog
        net-dns/bind-tools
        net-misc/curl
        sys-apps/lsb-release
        sys-apps/util-linux
        sys-fs/squashfs-tools
        "

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
