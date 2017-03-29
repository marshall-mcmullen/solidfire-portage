# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
inherit python-any-r1 solidfire-libs

DESCRIPTION="Collection of google libraries packaged by SolidFire."
HOMEPAGE="http://www.solidfire.com"
MODULES="gflags gtest gmock glog"
GFLAGS_VERSION="2.0-r5"
GTEST_VERSION="1.6.0-r7"
GMOCK_VERSION="1.6.0-r4"
GLOG_VERSION="0.3.3-r3"
SRC_URI="http://bitbucket.org/solidfire/gflags/get/solidfire/${GFLAGS_VERSION}.tar.bz2 -> gflags-${GFLAGS_VERSION}.tar.bz2
         http://bitbucket.org/solidfire/gtest/get/solidfire/${GTEST_VERSION}.tar.bz2   -> gtest-${GTEST_VERSION}.tar.bz2
		 http://bitbucket.org/solidfire/gmock/get/solidfire/${GMOCK_VERSION}.tar.bz2   -> gmock-${GMOCK_VERSION}.tar.bz2
		 http://bitbucket.org/solidfire/glog/get/solidfire/${GLOG_VERSION}.tar.bz2     -> glog-${GLOG_VERSION}.tar.bz2"

LICENSE="BSD"
SLOT="${PVR}"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

# SolidFire Libs Settings
SOLIDFIRE_WANT_EAUTORECONF=1

# NOTE: We want to build a cohesive version of all the google libraries we need so that they all compile and link against
# one another properly without having to specify the specific versions in both solidfire-libs as well as inside each
# of the google libraries. To accomplish that we have a single ebuild which knows how to build all the google libraries
# in a consistent manner. In order to get things to work properly, we must fully configure, compile and install each
# google library (or module) in its entirely before building the next one. Because of this, we can't use the piecemeal
# ebuild functions and instead must do everything in one function. We chose src_prepare to minimize ebuild rule breaking.
# Because of this, we have to stub out the other real functions so that nothing will happen if they are called.
for cmd in configure compile test; do eval "src_${cmd}() { :; }"; done
src_prepare()
{
	for module in ${MODULES}; do
		eval "module_version=\${${module^^}_VERSION}"
		ebanner "Module=${module} Version=${module_version}"
		pushd "${S}/${module}-${module_version}"

		#--------------------------------------------------------------------------------------------------------------
		# PREPARE
		#--------------------------------------------------------------------------------------------------------------
		phase "Preparing ${module}-${module_version}"
		append-cppflags "-I${S}/gflags/src -I${S}/gtest/include -I${S}/gmock/include -I${S}/glog/include"
		append-ldflags  "-L${S}/gflags/.libs -L${S}/gtest/lib/.libs -L${S}/gmock/lib/.libs -L${S}/glog/.libs"
		append-ldflags  "-Wl,--rpath=/sf/packages/${PF}/lib"

		# Gmock expects there to be a gtest subdirectory which we do not want to use since we're building
		# against an already built gtest instance controlled by this ebuild.
		if [[ ${module} == gmock ]]; then
			sed -i -e 's|^m4_include(gtest/m4/acx_pthread.m4)$|m4_include(../gtest-'${GTEST_VERSION}'/m4/acx_pthread.m4)|' configure.ac || die
		fi

		# Lock down all these packages to use our internal versions of all our own modules.
		sed -i -e "s|\-lgflags|\-lgflags-solidfire-${PVR}|g"                           					\
			   -e "s|\-lgtest|\-lgtest-solidfire-${PVR}|g"                             					\
			   -e "s|\-lgmock|\-lgmock-solidfire-${PVR}|g"                           					\
			   -e "s|\-lglog|\-lglog-solidfire-${PVR}|g"                           						\
			   -e "s|AC_CHECK_LIB(gflags|AC_CHECK_LIB(gflags-solidfire-${PVR}|g"      					\
			   -e "s|AC_CHECK_LIB(gtest|AC_CHECK_LIB(gtest-solidfire-${PVR}|g"         					\
			   -e "s|AC_CHECK_LIB(gmock|AC_CHECK_LIB(gmock-solidfire-${PVR}|g"         					\
			   -e "s|AC_CHECK_LIB(glog|AC_CHECK_LIB(glog-solidfire-${PVR}|g"         					\
			   -e "s|subdirs=.*|subdirs=\"\"|g"                                       					\
		 configure* Makefile* || die

		# google-libs expects python2 but their scripts don't lock that down.
		einfo "Updating python files to explicitly use python2"	
		local pyfile
		for pyfile in $(grep -lR '^#!/usr/bin/env python$' .); do
			echo " ${pyfile}"
			sed -i -e 's|^#!/usr/bin/env python$|#!/usr/bin/env python2|' "${pyfile}" || die
		done

		solidfire-libs_src_prepare

		#--------------------------------------------------------------------------------------------------------------
		# CONFIGURE
		#--------------------------------------------------------------------------------------------------------------
		phase "Configuring ${module}-${module_version}"

		if [[ ${module} == gtest ]]; then
			econf --enable-static --with-pthreads
		elif [[ ${module} == gmock ]]; then
			econf --enable-static --with-gtest=${PWD}/../gtest-${GTEST_VERSION}
		elif [[ ${module} == glog ]]; then
			econf --enable-static --with-gflags=${PWD}/../gflags
		else
			econf --enable-static
		fi
		
		if [[ ${module} == @(gtest|gmock) ]]; then
			sed -i -e "s|# This library was specified with -dlpreopen.|if [[ \"\${name}\" -eq '${module}' ]]; then name='${module}-solidfire-${PVR}'; fi\n    # This library was specified with -dlpreopen.|" \
				libtool || die

			sed -i -e "s|lib/lib${module}.la|lib/${PF}/lib${PF}.la|g"                                 \
				   -e "s|${module}_libs=\"-l\${name}|${module}_libs=\"-l${module}-solidfire-${PVR}|g" \
				scripts/${module}-config || die
		fi
	
		#--------------------------------------------------------------------------------------------------------------
		# COMPILE
		#--------------------------------------------------------------------------------------------------------------
		phase "Compiling ${module}-${module_version}"
		emake || die

		#--------------------------------------------------------------------------------------------------------------
		# TEST
		#--------------------------------------------------------------------------------------------------------------
		#einfo "Testing ${module}-${module_version}"
		#emake test || die

		#--------------------------------------------------------------------------------------------------------------
		# INSTALL
		#--------------------------------------------------------------------------------------------------------------
		phase "Installing ${module}-${module_version}"
	
		if [[ ${module} == gtest ]]; then
			emake DESTDIR="${PORTAGE_BUILDDIR}/image.internal" install-libLTLIBRARIES install-m4dataDATA install-pkgincludeHEADERS install-pkginclude_internalHEADERS || die
		elif [[ ${module} == gmock ]]; then
			emake DESTDIR="${PORTAGE_BUILDDIR}/image.internal" install-libLTLIBRARIES install-pkgincludeHEADERS install-pkginclude_internalHEADERS || die
		else
			emake DESTDIR="${PORTAGE_BUILDDIR}/image.internal" install
		fi

		popd
	done
}

# In the src_install function we move over the tree we installed in src_prepare into image.internal. The reason we 
# cannot just install into ${D} in src_prepare is that the internal ebuild __dyn_install function always does a forced
# 'rm -rf ${D}' then creates it fresh before calling src_install() which would have the effect of removing all the 
# files we just installed. Thus we stage them in image.internal, and then move them over in src_install to make things
# work properly.
src_install()
{
	# Remove the empty ${D} created by __dyn_install then move over our image.internal tree to expected ${D} path.
	rmdir "${D}"
	mv "${PORTAGE_BUILDDIR}/image.internal" "${D}"

	# Include dir has all header files duplicated in 'google' dir. Silly Google.
	rm -rf "${DP}/include/google" || die

	# Remove some directories we don't care about
	rm -rf "${DP}/share" "${DP}/bin" || die
}
