# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit distbox-solidfire

DESCRIPTION="Allow SolidFire team to share idle resources on your workstation."
HOMEPAGE="http://solidfire.com"
SRC_URI="https://bitbucket.org/solidfire/${MY_PN}/get/${MY_PN}-${PVR}.tar.bz2 -> ${PF}.tar.bz2"

DEPEND=">=dev-util/bashutils-solidfire-0.7.5
		app-portage/gentoolkit
		dev-vcs/mercurial
		app-arch/pigz
		virtual/jre
		net-misc/curl
		app-misc/jq
		net-misc/openssh
		sys-devel/make"
RDEPEND="${DEPEND}"
