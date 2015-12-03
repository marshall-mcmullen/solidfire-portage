# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit distbox-solidfire

DESCRIPTION="Allow SolidFire team to share idle resources on your workstation."
HOMEPAGE="http://solidfire.com"
EHG_REPO_URI="http://hgserve.eng.solidfire.net/hg/${MY_PN}"
EHG_REVISION="386d7d89cf0"

DEPEND="=dev-util/bashutils-solidfire-1.1.11
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
