# Copyright 2011-2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire-libs

DESCRIPTION="SolidFire cluster healthtools"
HOMEPAGE="solidfire.com"
SRC_URI="https://bitbucket.org/solidfire/${MY_PN}/get/v${PV}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="SolidFire"
KEYWORDS="amd64"
IUSE=""

# Buildtime dependencies
DEPEND="
    =dev-util/bashutils-solidfire-1.4.13
    >=dev-python/pyinstaller-3.2"

# Runtime dependencies
RDEPEND="
    >=dev-python/isoparser-0.3
    >=dev-python/netaddr-0.7.18
    >=dev-python/six-1.10.0
    www-misc/fcgiwrap"

src_compile()
{
    emake setup
    emake build_all_components
}

src_install()
{
    # Install binaries and then unversion them since they are already in fully versioned application specific directories
    dobin build/components/*
    einfo "Unverisoning binaries"
    for bin in ${DP}/bin/*-${PV}; do
        mv --verbose "${bin}" "${bin%%-${PV}}"
    done

    # Install nginx config files and remove /etc/default as that's not needed or used on systemd
    doins -r files/etc
    einfo "Removing /etc/default"
    rm --recursive --verbose "${DP}/etc/default"
}
