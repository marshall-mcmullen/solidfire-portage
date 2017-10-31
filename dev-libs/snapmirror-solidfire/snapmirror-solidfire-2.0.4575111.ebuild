# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit solidfire-libs

DESCRIPTION="NetApp SnapMirror replicates data through ONTAP."
HOMEPAGE="www.netapp.com"
SRC_URI="http://bdr-jenkins.den.solidfire.net/libs/distfiles/${MY_PF%.*}-${MY_PF##*.}.tar.gz -> ${MY_PF}.tar.gz"

LICENSE="NetApp"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare()
{
	solidfire-libs_src_prepare

	# Set the compiler as CC and CXX are not honored.
	sed -i -e "s|^CC=.*|CC=$(tc-getCXX)|" $(find . -name Makefile) \
		|| die "Failed to set compiler"

	sed -i -e 's|TARGETS = $(UUIDDIR) $(SPINNPDIR) $(SMAGENT) $(BTRFS) $(LRSE_TEST)|TARGETS = $(UUIDDIR) $(SPINNPDIR) $(SMAGENT)|' Makefile \
		|| die "Failed to set TARGETS"

	sed -i -e 's|TARGETS = $(TESTDIR)||' smagent/Makefile \
		|| die "Failed to clear smagent TARGETS"

	chmod +x spinnpv2/convert-spinnp.sh
}

src_install()
{
	# Header files
	doheader "${S}/smagent/sma_interface.h"
	doheader "${S}/smagent/sma_status.h"

	# Libraries
	dolib "${S}/smagent/libsmagent.a"
	dolib "${S}/spinnpv2/libspinnp.a"
	dolib "${S}/uuid/libsmuuid.a"
}
