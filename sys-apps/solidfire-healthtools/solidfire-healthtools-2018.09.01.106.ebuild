# Copyright 2011-2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="SolidFire cluster healthtools"
HOMEPAGE="solidfire.com"
SRC_URI="https://bitbucket.org/solidfire/${UPSTREAM_PN}/get/v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="SolidFire"
KEYWORDS="amd64"
IUSE=""

# Buildtime dependencies
DEPEND="
	=dev-util/bashutils-solidfire-1.4.13"

# Runtime dependencies
RDEPEND="
	>=dev-python/isoparser-0.3
	>=dev-python/netaddr-0.7.18
	>=dev-python/six-1.10.0
	sys-cluster/zookeeper-tools-solidfire
	>=www-misc/fcgiwrap-1.1.0-r2"

src_compile()
{
	emake setup
    emake build_all_components
    emake package_tarball
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

	dopathlinks_lstrip "/sf" "${DP}" $(find ${DP}/bin -type f)
    dopathlinks_lstrip "/usr/local" "${DP}" $(find ${DP}/bin -type f)
    mkdir -p "${DP}"/sf/healthtools-staging
    cp build/${P}.tgz "${DP}"/sf/healthtools-staging
    pushd "${DP}"/sf/healthtools-staging
    tar zxvf ${P}.tgz
    tar zxvf "${P}"/components.tgz
    rm ${P}.tgz
    popd
    dopathlinks /sf/ "${DP}"/sf/healthtools-staging
    mkdir -p "${DP}"/sf/doc
    cp files/sf/doc/* "${DP}"/sf/doc/
}

pkg_postinst()
{
    solidfire_pkg_postinst
    touch /var/log/sf-healthtools.info || die
    chown nginx:nginx /var/log/sf-healthtools.info || die
    chmod 666 /var/log/sf-healthtools.info || die
}


