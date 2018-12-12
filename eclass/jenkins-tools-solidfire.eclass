

# $Id$

#
# Original Author: modell
# Purpose: 
#

if [[ -z ${_JENKINS_TOOLS_ECLASS} ]]; then
JENKINS_TOOLS_ECLASS=1

inherit solidfire

EXPORT_FUNCTIONS src_install

LICENSE="Apache-2.0"
KEYWORDS="amd64"

jenkins-tools-solidfire_src_install()
{
	DESTDIR=${DP} ${S}/.forge/install || die "Unable to call .forge/install"
}

fi
