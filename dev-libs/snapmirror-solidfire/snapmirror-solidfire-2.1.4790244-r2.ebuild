# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5

inherit solidfire

DESCRIPTION="NetApp SnapMirror replicates data through ONTAP."
HOMEPAGE="www.netapp.com"
SRC_URI="http://bdr-jenkins.den.solidfire.net/distfiles/${UPSTREAM_PF%.*}-${UPSTREAM_PF##*.}.tar.gz -> ${UPSTREAM_P}.tar.gz"

LICENSE="NetApp"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare()
{
	solidfire_src_prepare

	# Set the compiler as CC and CXX are not honored.
	sed -i -e "s|^CC=.*|CC=$(tc-getCXX)|" $(find . -name Makefile) \
		|| die "Failed to set compiler"

	sed -i -e "s|/usr/software/bin/ar|ar|" $(find . -name Makefile) || die "Failed to reset ar command"

	sed -i -e 's|TARGETS = $(UUIDDIR) $(SPINNPDIR) $(SMAGENT) $(BTRFS) $(LRSE_TEST)|TARGETS = $(UUIDDIR) $(SPINNPDIR) $(SMAGENT)|' Makefile \
		|| die "Failed to set TARGETS"

	sed -i -e 's|TARGETS = $(TESTDIR)||' smagent/Makefile \
		|| die "Failed to clear smagent TARGETS"

	chmod +x spinnpv2/convert-spinnp.sh

	# Fix bug discovered by newer GCC 6.4 compiler around their logging macro
	sed -i -e 's|"fmt|"#fmt|g' $(find smagent -type f) \
		|| die "Failed to patch smagent logging macros"
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
