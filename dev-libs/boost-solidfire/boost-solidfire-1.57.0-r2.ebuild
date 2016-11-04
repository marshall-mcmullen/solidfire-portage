# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
inherit versionator solidfire-libs

MY_P="${MY_PN}_$(replace_all_version_separators _)"
MAJOR_V="$(get_version_component_range 1-2)"

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="http://www.boost.org/"
SRC_URI="mirror://sourceforge/boost/${MY_P}.tar.bz2"

LICENSE="Boost-1.0"
KEYWORDS="amd64"

RDEPEND="app-arch/bzip2
	sys-libs/zlib
	!app-admin/eselect-boost"
DEPEND="${RDEPEND}"

PATCHES="explicit_stored_group.patch
	throw_message.patch"

S="${WORKDIR}/${MY_P}"

src_configure()
{
	sed -i -e "s|result = \$(result)\.\$(BOOST_VERSION)  ;|result = lib\$(name)${PS}\.so ;|" \
		boostcpp.jam || die

	# SET COMPILER AND COMPILER FLAGS
	echo "using gcc : : $(tc-getCXX) : <compileflags>\"${CXXFLAGS}\" <linkflags>\"${LDFLAGS}\" ;" > user-config.jam
	
	export BOOST_ROOT="${S}"
	./bootstrap.sh || die "bootstrapp.sh failed"
}

# Common BJAM args
OPTIONS="-j$(nproc) -q -d+2
	--ignore-site-config
	--user-config=user-config.jam
	--without-python
	--without-mpi
	--includedir=${DP}/include
	--libdir=${DP}/lib"

src_compile()
{
	einfo "bjam ${OPTIONS}"
	./bjam ${OPTIONS} || die "bjam stage failed"
}

src_install()
{
	export BOOST_ROOT="${S}"
	einfo "bjam ${OPTIONS} install"
	./bjam ${OPTIONS} install || die "bjam install failed"
}

# the tests will never fail because these are not intended as sanity
# tests at all. They are more a way for upstream to check their own code
# on new compilers. Since they would either be completely unreliable
# (failing for no good reason) or completely useless (never failing)
# there is no point in having them in the ebuild to begin with.
RESTRICT=test
src_test() { :; }
