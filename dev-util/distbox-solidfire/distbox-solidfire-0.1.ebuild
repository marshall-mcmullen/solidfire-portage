# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit mercurial systemd

DESCRIPTION="Allow SolidFire team to share idle resources on your workstation."
HOMEPAGE="http://solidfire.com"
MY_PN="${PN/-solidfire/}"
EHG_REPO_URI="http://hgserve.eng.solidfire.net/hg/${MY_PN}"
EHG_REVISION="2c5192932d6b"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	>=dev-util/bashutils-solidfire-0.7.4
	dev-vcs/mercurial
	app-arch/pigz
	virtual/jre
	net-misc/curl
	app-misc/jq
	net-misc/openssh
	sys-devel/make
"

RDEPEND="${DEPEND}"

src_prepare()
{
	echo "Preparing..."
	sed -ie ${S}/bin/distbox -e 's|${DISTBOX_VERSION}|'${PVR}'|g'
}

src_install()
{
	doinitd ${S}/init/${MY_PN}
	insinto /etc/${MY_PN}
	doins ${S}/etc/*
	dobin ${S}/bin/*

	# Install systemd unit
	systemd_dounit ${S}/systemd/${MY_PN}.service
}

pkg_postinst()
{
	[[ -e /etc/distbox/user.conf ]] || touch /etc/distbox/user.conf
}
