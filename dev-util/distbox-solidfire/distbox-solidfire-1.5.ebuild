# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit mercurial systemd

DESCRIPTION="Allow SolidFire team to share idle resources on your workstation."
HOMEPAGE="http://solidfire.com"
MY_PN="${PN/-${VTAG}/}"
EHG_REPO_URI="http://hgserve.eng.solidfire.net/hg/${MY_PN}"
EHG_REVISION="9db12727d6ec"

################################################################################
# To use a local copy of the distbox repository, uncomment the following, and
# change "/home/modell/sf/distbox" to the location of your distbox repo.
#
#unset EHG_REPO_URL
#unset EHG_REVISION
#SRC_URI=""
#src_unpack()
#{
#	pushd /home/modell/sf/distbox
#	tar cf - . --exclude .hg --transform 's#./#'${PF}'/#' | (cd ${WORKDIR} ; tar xf -)
#	popd
#}
################################################################################

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	>=dev-util/bashutils-solidfire-0.8.7
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
	app-text/xmlstarlet
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
