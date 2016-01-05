# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: marshall
# Purpose: 
#

if [[ -z ${_DISTBOX_ECLASS} ]]; then
_DISTBOX_ECLASS=1

EAPI=5

inherit systemd

EXPORT_FUNCTIONS src_unpack src_prepare src_install pkg_postinst

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

# Setup variables to upstream source that doesn't have solidfire in it.
MY_P="${P//-solidfire}"
MY_PN="${PN//-solidfire}"
MY_PF="${PF//-solidfire}"
PS="-solidfire-${PVR}"
S="${WORKDIR}/${MY_P}"

#-----------------------------------------------------------------------------
# SolidFire Distbox Public ebuild methods
#-----------------------------------------------------------------------------

distbox-solidfire_src_unpack()
{
	# To use a local copy of the distbox repository, simply export
	# SOLIDFIRE_DISTBOX_LOCAL_PATH to the local path on your filesystem.
	if [[ -n ${SOLIDFIRE_DISTBOX_LOCAL_PATH} ]]; then
		SRC_URI=""

		pushd ${SOLIDFIRE_DISTBOX_LOCAL_PATH}
		tar cf - . --exclude .hg --transform 's#./#'${PF}'/#' | (cd ${WORKDIR} ; tar xf -)
		popd
	else
		default
	fi
}

distbox-solidfire_src_prepare()
{
	local BASHUTILS_VERSION=$(echo "${DEPEND}"			\
		| grep -o "=dev-util/bashutils-solidfire-\S\+"	\
		| awk -F- '{print $NF}'; )

	sed -i ${S}/bin/distbox* -e 's|${DISTBOX_VERSION}|'${PVR}'|g'
	sed -i ${S}/bin/distbox* -e 's|${BASHUTILS_VERSION}|'${BASHUTILS_VERSION}'|g'
}

distbox-solidfire_src_install()
{
	into /usr/local

	doinitd ${S}/init/${MY_PN}
	insinto /etc/${MY_PN}
	doins -r ${S}/etc/*
	dobin ${S}/bin/*

	# Install systemd unit
	systemd_dounit ${S}/systemd/${MY_PN}.service
}

distbox-solidfire_pkg_postinst()
{
	[[ -e /etc/distbox/user.conf ]] || touch /etc/distbox/user.conf
	/usr/local/bin/distbox install_cron
	/usr/local/bin/distbox fix_sudoers
}

fi
