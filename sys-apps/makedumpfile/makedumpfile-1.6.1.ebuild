# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

DESCRIPTION="A tool to make a compact kdump file."
HOMEPAGE="https://www.sourceforge.net/projects/makedumpfile"
SRC_URI="https://www.sourceforge.net/projects/makedumpfile/files/makedumpfile/${PV}/makedumpfile-${PV}.tar.gz"

LICENSE="GPLv2"
KEYWORDS="~amd64 amd64"

SLOT="0"

src_compile()
{
	# This tells the makedumpfile Makefile to not attempt static linking.
	export LINKTYPE="dynamic"
	emake
}
