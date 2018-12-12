# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Collection of bash utilities for simpler and more robust bash programming"
HOMEPAGE="https://bitbucket.org/solidfire/bashutils"
SRC_URI="https://bitbucket.org/solidfire/${UPSTREAM_PN}/get/${UPSTREAM_P}.tar.bz2 -> ${P}.tar.bz2"

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
        sys-apps/file
        sys-apps/lsb-release
        sys-apps/util-linux
        sys-boot/syslinux
        sys-fs/squashfs-tools
        "

RDEPEND="${DEPEND}"

SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/usr/local/share/${UPSTREAM_P}" )

src_install()
{
    DESTDIR=${D}/sf/packages/${P} PV=${PV} ${S}/.forge/install || die
    dobinlinks ${DP}/bin/*
}

src_compile()
{
    true
}
