# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Allow SolidFire team to share idle resources on your workstation."
HOMEPAGE="http://solidfire.com"

# Setup variables to upstream source that doesn't have solidfire in it.
MY_P="${P//-solidfire}"
MY_PN="${PN//-solidfire}"
MY_PF="${PF//-solidfire}"
PS="-solidfire-${PVR}"
S="${WORKDIR}/${MY_P}"

SRC_URI="${MY_PF}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="=dev-util/bashutils-solidfire-1.3.1
        =dev-util/jenkins-tools-solidfire-1.0.4
		dev-util/debootstrap
		app-portage/gentoolkit
		virtual/jre
		net-misc/curl
		net-misc/openssh
		app-admin/sudo
		sys-apps/lsb-release
		app-text/xmlstarlet
		app-misc/jq"

RDEPEND="${DEPEND}"

src_install()
{
	DESTDIR=${D}/sf/packages/${P} PV=${PV} ${S}/.forge/install || die
}

pkg_postinst()
{
	/sf/packages/${P}/.forge/postinst || die
}
