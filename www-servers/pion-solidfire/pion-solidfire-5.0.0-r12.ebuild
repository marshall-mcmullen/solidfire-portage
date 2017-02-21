# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="C++ framework for building light weight HTTP interfaces"
HOMEPAGE="https://github.com/cloudmeter/pion"
SRC_URI="https://bitbucket.org/solidfire/pion/get/solidfire/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="Boost-1.0"
KEYWORDS="~amd64 amd64"

BOOST_VERSION="1.57.0-r2"
DEPEND="dev-vcs/git
	=dev-libs/boost-solidfire-${BOOST_VERSION}"
RDEPEND="${DEPEND}
	app-arch/bzip2
	dev-libs/openssl
	dev-libs/icu"

LICENSE="Boost-1.0"
REVISION="0"

src_prepare()
{
	export AUTOHEADER="/bin/true"
	mkdir m4
	autoreconf -ifs

	solidfire-libs_src_prepare

	# Append boost specific flags
	append-cppflags "-DBOOST_FILESYSTEM_VERSION=3 -DBOOST_NO_CXX11_EXPLICIT_CONVERSION_OPERATORS"
	append-cppflags "-I/sf/packages/boost-solidfire-${BOOST_VERSION}/include"
	append-ldflags  "-L/sf/packages/boost-solidfire-${BOOST_VERSION}/lib"
	append-ldflags  "-Wl,--rpath=/sf/packages/boost-solidfire-${BOOST_VERSION}/lib"
}

src_configure()
{
	econf                        \
		--disable-doxygen-doc	 \
		--disable-doxygen-html 	 \
		--disable-tests 		 \
		--disable-logging 		 \
		--with-plugins="${PREFIX}/share/plugins" \
		--with-boost-extension="-solidfire-${BOOST_VERSION}"

	sed -i -e "s|\(# This library was specified with -dlpreopen.\)|if [[ \"\${name}\" -eq 'pion' ]]; then name='${PF}'; fi\n\1|" libtool \
		|| die "libtool patch failed"
}

src_install()
{
	default
	doheader include/pion/config.hpp
}
