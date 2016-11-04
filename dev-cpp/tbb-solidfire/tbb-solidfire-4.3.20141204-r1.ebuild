# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs versionator

PV1="$(get_version_component_range 1)"
PV2="$(get_version_component_range 2)"
PV3="$(get_version_component_range 3)"
MYP="${MY_PN}${PV1}${PV2}_${PV3}oss"

DESCRIPTION="Intel Threading Building Blocks"
HOMEPAGE="http://threadingbuildingblocks.org"
SRC_URI="http://threadingbuildingblocks.org/sites/default/files/software_releases/source/${MYP}_src.tgz"
LICENSE="GPL-2-with-exceptions"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES="case-413-4.3.patch"

S="${WORKDIR}/${MYP}"

src_prepare()
{
	solidfire-libs_src_prepare
	
	sed -i -e "s|soname=\$(BUILDING_LIBRARY)|soname=\$(patsubst %.so.\$(SONAME_SUFFIX),%${PS}.so,\$(BUILDING_LIBRARY))|" \
		build/linux.gcc.inc || die

	sed -i -e "s|default_tbb: \$(TBB.DLL)|default_tbb: \$(TBB.DLL) libtbb.a|" \
		   -e "s|ifneq (,\$(TBB_NO_VERSION.DLL))|libtbb.a: \$(TBB.OBJ) \$(TBB.RES) tbbvars.sh \$(TBB_NO_VERSION.DLL)\n\tar cr \$@ \$(TBB.OBJ)\n\nifneq (,\$(TBB_NO_VERSION.DLL))|" \
		build/Makefile.tbb || die

	# Disable debug builds
	sed -i -e '/_debug/d' Makefile
}

src_compile()
{
	emake info
	emake compiler=gcc tbb_root="${S}" lambdas=1 cpp0x=1
}

src_install()
{
	# Header files
	doheader -r include/*

	# Libraries
	local tbb_prefix=$(make info | grep tbb_build_prefix | cut -d= -f2)
	dolib.so build/${tbb_prefix}_release/{libtbb.so.2,libtbbmalloc.so.2,libtbbmalloc_proxy.so.2}
	dolib.a  build/${tbb_prefix}_release/libtbb.a
}
