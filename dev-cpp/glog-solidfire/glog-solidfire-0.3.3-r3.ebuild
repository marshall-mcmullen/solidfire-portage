# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="Google's C++ logging module"
HOMEPAGE="http://code.google.com/p/google-glog"
SRC_URI="http://google-${MY_PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"
IUSE="test"

GFLAGS_VERSION=2.0-r5
GTEST_VERSION=1.6.0-r7
DEPEND="=dev-cpp/gflags-${VTAG}-${GFLAGS_VERSION}
	=dev-cpp/gtest-${VTAG}-${GTEST_VERSION}"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/case-73.patch"
	"${FILESDIR}/gcc-4.7_string_literals.patch"
	"${FILESDIR}/logprefix.patch"
)

src_configure()
{
	use test || export ac_cv_prog_GTEST_CONFIG=no
	sed -i -e "s|gtest-config|gtest-config-${VTAG}-${GTEST_VERSION}|g" 					\
		   -e "s|\-lgflags|\-lgflags-${VTAG}-${GFLAGS_VERSION}|g"						\
		   -e "s|\-lgtest|\-lgtest-${VTAG}-${GTEST_VERSION}|g" 							\
		   -e "s|AC_CHECK_LIB(gflags|AC_CHECK_LIB(gflags-${VTAG}-${GFLAGS_VERSION}|g" 	\
		   -e "s|AC_CHECK_LIB(gtest|AC_CHECK_LIB(gtest-${VTAG}-${GTEST_VERSION}|g" 		\
		configure || die

	append-cppflags "-I/usr/include/gflags-${VTAG}-${GFLAGS_VERSION} -I/usr/include/gtest-${VTAG}-${GTEST_VERSION}"
	append-ldflags  "-L/usr/lib/gflags-${VTAG}-${GFLAGS_VERSION}     -L/usr/lib/gtest-${VTAG}-${GTEST_VERSION}"
	
	versionize_src_configure
}
