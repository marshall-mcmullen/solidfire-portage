# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: modell
# Purpose: 
#

if [[ -z ${_JENKINS_TOOLS_ECLASS} ]]; then
JENKINS_TOOLS_ECLASS=1

inherit solidfire-libs

LICENSE="Apache-2.0"
KEYWORDS="amd64"

jenkins-tools-solidfire_src_prepare()
{
	${S}/.forge/install || die "Unable to call .forge/install"
}

jenkins-tools-solidfire_src_install()
{
	insinto ${PREFIX}
    doins ${S}/.forge/work/image/*
}

fi
