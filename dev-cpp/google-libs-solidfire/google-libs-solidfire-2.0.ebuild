# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
inherit python-any-r1 solidfire-libs git-r3

DESCRIPTION="Collection of google libraries packaged by SolidFire."
HOMEPAGE="http://www.solidfire.com"
EGIT_REPO_URI="https://bitbucket.org/solidfire/google-libs.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="${PVR}"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

# SolidFire Libs Settings
SOLIDFIRE_WANT_EAUTORECONF=1

# Versions of all packages that this metapackage installs
MODULES="gflags gtest gmock glog"
GFLAGS_VERSION="2.0-p5"
GLOG_VERSION="0.3.3-p3"
GMOCK_VERSION="1.6.0-p4"
GTEST_VERSION="1.6.0-p7"

ebanner()
{
	local cols=${COLUMNS:-80}
	cols=$((cols-2))
	eval "local str=\$(printf -- '-%.0s' {1..${cols}})"
	printf "\n+${str}+\n|\n| $@\n|\n+${str}+\n"
}

src_prepare()
{
	append-cppflags "-I${S}/gflags/src -I${S}/gtest/include -I${S}/gmock/include -I${S}/glog/include"
	append-ldflags  "-L${S}/gflags/.libs -L${S}/gtest/lib/.libs -L${S}/gmock/lib/.libs -L${S}/glog/.libs"
	append-ldflags  "-Wl,--rpath=/sf/packages/${PF}/lib"

	local module module_version
	for module in ${MODULES}; do
		ebanner "Preparing ${module}"
		pushd "${S}/${module}"

		eval "module_version=\${${module^^}_VERSION}"
		git checkout "solidfire/${module_version}" || die

		# Gmock expects there to be a gtest subdirectory which we do not want to use since we're building
		# against an already built gtest instance controlled by this ebuild.
		if [[ ${module} == gmock ]]; then
			sed -i -e '\|^m4_include(gtest/m4/acx_pthread.m4)$|d' configure.ac || die
		fi

		# Lock down all these packages to use our internal versions of all our own modules.
		sed -i -e "s|\-lgflags|\-lgflags-solidfire-${PV}|g"                           					\
			   -e "s|\-lgtest|\-lgtest-solidfire-${PV}|g"                             					\
			   -e "s|\-lgmock|\-lgmock-solidfire-${PV}|g"                           					\
			   -e "s|\-lglog|\-lglog-solidfire-${PV}|g"                           						\
			   -e "s|AC_CHECK_LIB(gflags|AC_CHECK_LIB(gflags-solidfire-${PV}|g"      					\
			   -e "s|AC_CHECK_LIB(gtest|AC_CHECK_LIB(gtest-solidfire-${PV}|g"         					\
			   -e "s|AC_CHECK_LIB(gmock|AC_CHECK_LIB(gmock-solidfire-${PV}|g"         					\
			   -e "s|AC_CHECK_LIB(glog|AC_CHECK_LIB(glog-solidfire-${PV}|g"         					\
			   -e "s|subdirs=.*|subdirs=\"\"|g"                                       					\
		 configure* Makefile*

		# google-libs expects python2 but their scripts don't lock that down.
		echo ">>> Updating python files to explicitly use python2"	
		local pyfile
		for pyfile in $(grep -lR '^#!/usr/bin/env python$' .); do
		    echo " ${pyfile}"
			sed -i -e 's|^#!/usr/bin/env python$|#!/usr/bin/env python2|' "${pyfile}"
		done

		solidfire-libs_src_prepare
		
		popd
	done
}

src_compile()
{
	for module in ${MODULES}; do
		ebanner "Configuring & Compiling ${module}"
		pushd "${S}/${module}"

		if [[ ${module} == gtest ]]; then
			econf --enable-static --with-pthreads
		else
			econf --enable-static
		fi

		default_src_compile

		popd
	done
}

src_test()
{
	for module in ${MODULES}; do
		ebanner "Testing ${module}"
		pushd "${S}/${module}"
		default_src_test
		popd
	done
}

src_install()
{
	for module in ${MODULES}; do
		ebanner "Installing ${module}"

		pushd "${S}/${module}"
		
		if [[ ${module} == gtest ]]; then
			emake DESTDIR="${D}" install-libLTLIBRARIES install-m4dataDATA install-pkgincludeHEADERS install-pkginclude_internalHEADERS
		elif [[ ${module} == gmock ]]; then
			emake DESTDIR=${D} install-libLTLIBRARIES install-pkgincludeHEADERS install-pkginclude_internalHEADERS
		else
			default_src_install
		fi

		# Include dir has all header files duplicated in 'google' dir. Silly Google.
		rm -rf "${DP}/include/google" || die

		# We don't need the _main*.so libraries and they don't link properly as they try to link to the system library
		# instead of our versioned one.
		rm -f ${DP}/lib/lib${module}_main-solidfire-${PV}*

		popd
	done
}
