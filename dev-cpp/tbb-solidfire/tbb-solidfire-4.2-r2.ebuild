# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="Intel Threading Building Blocks"
HOMEPAGE="http://threadingbuildingblocks.org"
SRC_URI="http://192.168.137.1/libs/distfiles/tbb-4.2.tar.gz"
#${HOMEPAGE}/sites/default/files/software_releases/source/${MY_PN}${MY_PV//\.}_20130725oss_src"

LICENSE="GPL-2-with-exceptions"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/case-413-4.1.patch"
	"${FILESDIR}/move_semantics.patch"
)

src_prepare()
{
	versionize_src_prepare

	sed -i -e "s|soname=\$(BUILDING_LIBRARY)|soname=\$(patsubst %.so.\$(SONAME_SUFFIX),%-${MY_PVR}.so,\$(BUILDING_LIBRARY))|" \
		   -e "s|CPLUS = g++|CPLUS = ${CXX}|"                                                                                 \
		build/linux.gcc.inc || die

	sed -i -e "s|default_tbb: \$(TBB.DLL)|default_tbb: \$(TBB.DLL) libtbb.a|" \
		   -e "s|ifneq (,\$(TBB_NO_VERSION.DLL))|libtbb.a: \$(TBB.OBJ) \$(TBB.RES) tbbvars.sh \$(TBB_NO_VERSION.DLL)\n\tar cr \$@ \$(TBB.OBJ)\n\nifneq (,\$(TBB_NO_VERSION.DLL))|" \
		build/Makefile.tbb || die
}

src_install()
{
	# Include files
	insinto $(dirv include)
	doins -r include/*
	rm -rf $(idirv include)/index.html $(idirv include)/serial || die

	# Library files
	insinto $(dirv lib)
	local tbb_prefix=$(make info | grep tbb_build_prefix | cut -d= -f2)
	doins -r $(find "build/${tbb_prefix}_release" -name "*.a" -o -name "*.la" -o -name "*.so*" -o -name "*.dylib*")
	
	versionize_src_postinst
}
