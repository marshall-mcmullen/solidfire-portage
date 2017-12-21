# Copyright 2011-2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire

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
	pushd build/components

	local name newname

	for name in * ; do
		newname="$(echo "${name}" | sed -r -e 's/^(.+)-[0-9].*$/\1/')"
		if [[ ${name} != ${newname} ]] ; then
			einfo "Renaming ${name} to ${newname}"
			mv ${name} ${newname}
		fi
	done

	popd
	dobin build/components/*

	# Install nginx config files
	doins -r files/etc
	einfo "Removing /etc/default"
	rm --recursive --verbose "${DP}/etc/default"
	dopathlinks_lstrip "/" "${DP}" $(find ${DP} -type f)

	# Modify socket path
	einfo "Setting socket path"
	sed -i -e 's|/var/run/fcgiwrap.socket|/run/fcgiwrap.sock|g' 	\
		"${DP}"/etc/nginx.conf.d/* "${DP}"/etc/nginx.legacy.conf.d/* 	\
		|| die "Failed to set socket path"
}
