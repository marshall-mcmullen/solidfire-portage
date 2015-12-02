# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/boost/boost-1.54.0-r1.ebuild,v 1.4 2014/04/28 07:20:08 pinkbyte Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionator versionize

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="http://www.boost.org/"
SRC_URI="mirror://sourceforge/boost/${MY_P//[-.]/_}.tar.bz2 -> ${MY_P}.tar.bz2"

LICENSE="Boost-1.0"
KEYWORDS="amd64"
MAJOR_V="$(get_version_component_range 1-2)"

RDEPEND="app-arch/bzip2
	sys-libs/zlib
	!app-admin/eselect-boost"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/explicit_stored_group.patch"
	"${FILESDIR}/throw_message.patch"
	"${FILESDIR}/boost-1.53.0-glibc-2.18-compat.patch"
)

S="${WORKDIR}/boost_${PV//\./_}"

src_configure()
{
	sed -i -e "s|result = \$(result)\.\$(BOOST_VERSION)  ;|result = lib\$(name)-${MY_PVR}\.so ;|" \
		boostcpp.jam || die

	# SET COMPILER AND COMPILER FLAGS
	echo "using gcc : : ${CXX} : <compileflags>\"${CXXFLAGS}\" <linkflags>\"${LDFLAGS}\" ;" > user-config.jam
	
	export BOOST_ROOT="${S}"
	./bootstrap.sh || die "bootstrapp.sh failed"
}

# Common BJAM args
OPTIONS="-j$(nproc) -q -d+2 --user-config=user-config.jam --without-python --without-mpi --includedir=${D}/$(dirv include) --libdir=${D}/$(dirv lib)"

src_compile()
{
	./bjam ${OPTIONS} || die "bjam stage failed"
}

src_install()
{
	export BOOST_ROOT="${S}"
	./bjam ${OPTIONS} install || die
	versionize_src_postinst
}

# the tests will never fail because these are not intended as sanity
# tests at all. They are more a way for upstream to check their own code
# on new compilers. Since they would either be completely unreliable
# (failing for no good reason) or completely useless (never failing)
# there is no point in having them in the ebuild to begin with.
RESTRICT=test
src_test() { :; }
