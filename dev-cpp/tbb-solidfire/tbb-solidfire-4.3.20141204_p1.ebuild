# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5
inherit toolchain-funcs solidfire

DESCRIPTION="Intel Threading Building Blocks"
HOMEPAGE="http://threadingbuildingblocks.org"
SRC_URI="http://bitbucket.org/solidfire/${UPSTREAM_PN}/get/solidfire/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare()
{
	solidfire_src_prepare
	
	sed -i -e "s|soname=\$(BUILDING_LIBRARY)|soname=\$(patsubst %.so.\$(SONAME_SUFFIX),%${PS}.so,\$(BUILDING_LIBRARY))|" \
		build/linux.gcc.inc || die

	sed -i -e "s|default_tbb: \$(TBB.DLL)|default_tbb: \$(TBB.DLL) libtbb.a|" \
		   -e "s|ifneq (,\$(TBB_NO_VERSION.DLL))|libtbb.a: \$(TBB.OBJ) \$(TBB.RES) tbbvars.sh \$(TBB_NO_VERSION.DLL)\n\tar cr \$@ \$(TBB.OBJ)\n\nifneq (,\$(TBB_NO_VERSION.DLL))|" \
		build/Makefile.tbb || die

	# Make adjustments required for GCC 7.3 and higher
	if tc-is-gcc && [[ ( $(gcc-major-version) -gt 7 ) || $(gcc-major-version) -eq 7 && $(gcc-minor-version) -ge 3 ]]; then
		sed -i -e 's|#define __TBB_CPP11_TYPE_PROPERTIES_PRESENT .*|#define __TBB_CPP11_TYPE_PROPERTIES_PRESENT         1|' \
			include/tbb/tbb_config.h || die "Failed to set __TBB_CPP11_TYPE_PROPERTIES_PRESENT"
	fi

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
