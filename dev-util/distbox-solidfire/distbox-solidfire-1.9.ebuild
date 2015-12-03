# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit distbox-solidfire

DESCRIPTION="Allow SolidFire team to share idle resources on your workstation."
HOMEPAGE="http://solidfire.com"
EHG_REPO_URI="http://hgserve.eng.solidfire.net/hg/${MY_PN}"
EHG_REVISION="ba4fe7be8e47"

DEPEND="=dev-util/bashutils-solidfire-0.8.20
		app-portage/gentoolkit
		dev-vcs/mercurial
		app-arch/pigz
		virtual/jre
		net-misc/curl
		>=net-p2p/murder-solidfire-0.1.2-r2
		app-misc/jq
		net-misc/openssh
		sys-devel/make
		sys-devel/distcc
		app-admin/sudo
		app-text/xmlstarlet"
RDEPEND="${DEPEND}"
