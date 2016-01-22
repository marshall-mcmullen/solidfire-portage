# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-r3 distbox-solidfire

DESCRIPTION="Allow SolidFire team to share idle resources on your workstation."
HOMEPAGE="http://solidfire.com"

EGIT_REPO_URI="git@bitbucket.org:solidfire/distbox.git"
EGIT_BRANCH=${SOLIDFIRE_DISTBOX_BRANCH:-master}
EGIT_CHECKOUT_DIR=${WORKDIR}/${MY_P}

KEYWORDS="~amd64"

DEPEND="dev-util/debootstrap
		app-portage/gentoolkit
		virtual/jre
		net-misc/curl
		net-misc/openssh
		app-admin/sudo
		sys-apps/lsb-release
		app-text/xmlstarlet
		app-misc/jq"

RDEPEND="${DEPEND}"

src_unpack()
{
	# To use a local copy of the distbox repository, simply export
	# SOLIDFIRE_DISTBOX_LOCAL_PATH to the local path on your filesystem.
	if [[ -n ${SOLIDFIRE_DISTBOX_LOCAL_PATH} ]]; then
		einfo "Using local distbox repo ${SOLIDFIRE_DISTBOX_LOCAL_PATH}"
		pushd ${SOLIDFIRE_DISTBOX_LOCAL_PATH}
		tar cf - . --exclude .hg --transform 's#./#'${MY_PF}'/#' | (cd ${WORKDIR} ; tar xf -)
		popd
	else
		git-r3_src_unpack
	fi

	source ${S}/package.exports || die "Unable to source distbox's package.exports"
	[[ -d /var/db/pkg/dev-util/bashutils-solidfire-${BASHUTILS_VERSION} ]] \
		|| die "Required bashutils version ${BASHUTILS_VERSION} is not installed."
}

