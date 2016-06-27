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

EXPORT_FUNCTIONS src_prepare src_install pkg_postinst

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

distbox-solidfire_src_prepare()
{
	source ${S}/package.exports || die "Failed to source distbox package exports."

	sed -i ${S}/bin/distbox* -e 's|${DISTBOX_VERSION}|'${PVR}'|g'
	sed -i ${S}/bin/distbox* -e 's|${BASHUTILS}|'${BASHUTILS}'|g'
	sed -i ${S}/bin/distbox* -e 's|${BASHUTILS_VERSION}|'${BASHUTILS_VERSION}'|g'
	sed -i ${S}/bin/distbox* -e 's|${JENKINS_TOOLS_VERSION}|'${JENKINS_TOOLS_VERSION}'|g'
	sed -i ${S}/bin/distbox* -e 's|${JENKINS_TOOLS_HOME}|'${JENKINS_TOOLS_HOME}'|g'
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
