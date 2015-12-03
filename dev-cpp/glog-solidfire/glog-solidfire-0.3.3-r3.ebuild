# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="Google's C++ logging module"
HOMEPAGE="http://code.google.com/p/google-glog"
SRC_URI="http://google-${MY_PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"
IUSE="test"

DEPEND="=sys-devel/gcc-solidfire-4.8.1
	=dev-cpp/gflags-solidfire-2.0-r5
	=dev-cpp/gtest-solidfire-1.6.0-r7"
RDEPEND="${DEPEND}"

PATCHES="case-73.patch
	gcc-4.7_string_literals.patch
	logprefix.patch"

src_configure()
{
	use test || export ac_cv_prog_GTEST_CONFIG=no
	sed -i -e "s|gtest-config|gtest-config-solidfire-${GTEST_VERSION}|g" 					\
		   -e "s|\-lgflags|\-lgflags-solidfire-${GFLAGS_VERSION}|g"						    \
		   -e "s|\-lgtest|\-lgtest-solidfire-${GTEST_VERSION}|g" 							\
		   -e "s|AC_CHECK_LIB(gflags|AC_CHECK_LIB(gflags-solidfire-${GFLAGS_VERSION}|g" 	\
		   -e "s|AC_CHECK_LIB(gtest|AC_CHECK_LIB(gtest-solidfire-${GTEST_VERSION}|g" 		\
		configure || die

	econf
}
