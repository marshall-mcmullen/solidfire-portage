# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="NetApp Manageability SDK."
HOMEPAGE="www.netapp.com"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/netapp-manageability-sdk-${PV}.zip -> ${PF}.zip"

LICENSE="NetApp"
KEYWORDS="~amd64 amd64"
RESTRICT="strip"

DEPEND=">=dev-util/patchelf-0.9.0"

# We don't need or want solidfire-libs package unpack magic (munging) in this case
S="${WORKDIR}"
src_unpack()
{
    default_src_unpack
}

src_install()
{
	# Set the SONAME properly via patchelf then install the shared object
	pushd ${S}/netapp-manageability-sdk-${PV}/lib/linux-64
	
	for lib in libadt libnetapp libxml; do
		einfo "Setting SONAME on ${lib}"
		patchelf --debug --set-soname "${lib}-solidfire-${PV}.so" "${lib}.so" || die
		mv "${lib}.so" "${lib}-solidfire-${PV}.so"
		dolib "${lib}-solidfire-${PV}.so"
	done
	
	popd
}
