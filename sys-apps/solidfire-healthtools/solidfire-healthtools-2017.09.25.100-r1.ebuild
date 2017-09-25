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
    sys-cluster/zookeeper-tools-solidfire
    >=www-misc/fcgiwrap-1.1.0-r2"

SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=(
	"/etc/nginx.conf.d/sfinstalld_params.conf"
	"/etc/nginx.conf.d/upgrade_cluster.conf"
	"/etc/nginx.legacy.conf.d/upgrade_node.conf"
	"/sf/bin/sfinstalld"
)

src_compile()
{
    emake setup
    emake build_all_components
}

src_install()
{
    # Install binaries
    dobin build/components/*
	dosym "${PREFIX}/bin/sfinstalld" "/sf/bin/sfinstalld"

    # Install nginx config files
	mkdir -p "${D}/etc/nginx.conf.d"
	cp files/etc/nginx.conf.d/* "${D}/etc/nginx.conf.d"
	mkdir -p "${D}/etc/nginx.legacy.conf.d"
	cp files/etc/nginx.legacy.conf.d/* "${D}/etc/nginx.legacy.conf.d"

	# Modify socket path
	einfo "Setting socket path"
	sed -i -e 's|/var/run/fcgiwrap.socket|/run/fcgiwrap.sock|g' 	\
		"${D}"/etc/nginx.conf.d/* "${D}"/etc/nginx.legacy.conf.d/* 	\
		|| die "Failed to set socket path"
}
