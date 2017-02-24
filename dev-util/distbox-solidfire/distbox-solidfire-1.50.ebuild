# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit distbox-solidfire

DESCRIPTION="Allow SolidFire team to share idle resources on your workstation."
HOMEPAGE="http://solidfire.com"
SRC_URI="https://bitbucket.org/solidfire/${MY_PN}/get/${MY_PN}-${PVR}.tar.bz2 -> ${PF}.tar.bz2"

DEPEND="=dev-util/bashutils-solidfire-1.3.71
        =dev-util/jenkins-tools-solidfire-1.0.14
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
