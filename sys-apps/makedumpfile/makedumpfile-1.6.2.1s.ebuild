# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit base

SF_SUFFIX=".${PV##*.}"
MY_PV="${PV%%${SF_SUFFIX}}"

DESCRIPTION="A tool to make a compact kdump file."
HOMEPAGE="https://www.sourceforge.net/projects/makedumpfile"
SRC_URI="https://www.sourceforge.net/projects/makedumpfile/files/makedumpfile/${MY_PV}/makedumpfile-${MY_PV}.tar.gz"

DEPEND="dev-libs/elfutils"

LICENSE="GPLv2"
KEYWORDS="~amd64 amd64"

SLOT="0"

S="${WORKDIR}/${PN}-${MY_PV}"

# List of patches
PATCHES=(
	${FILESDIR}/take-care-of-init-level4-pgt-rename-in-kernel.patch
	${FILESDIR}/fix-SECTION_MAP_MASK-for-kernel-bigger-than-4.13.patch
)

src_compile()
{
	# This tells the makedumpfile Makefile to not attempt static linking.
	export LINKTYPE="dynamic"
	emake
}
