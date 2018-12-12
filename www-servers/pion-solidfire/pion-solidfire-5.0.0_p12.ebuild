

# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="C++ framework for building light weight HTTP interfaces"
HOMEPAGE="https://github.com/cloudmeter/pion"
SRC_URI="https://bitbucket.org/solidfire/pion/get/solidfire/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Boost-1.0"
KEYWORDS="~amd64 amd64"

BOOST_VERSION="solidfire-1.57.0_p2"
DEPEND="dev-vcs/git
	=dev-libs/boost-${BOOST_VERSION}"
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

	solidfire_src_prepare

	# Append boost specific flags
	append-cppflags "-DBOOST_FILESYSTEM_VERSION=3 -DBOOST_NO_CXX11_EXPLICIT_CONVERSION_OPERATORS"
	append-cppflags "-I/sf/packages/boost-${BOOST_VERSION}/include"
	append-ldflags  "-L/sf/packages/boost-${BOOST_VERSION}/lib"
	append-ldflags  "-Wl,--rpath=/sf/packages/boost-${BOOST_VERSION}/lib"
}

src_configure()
{
	econf                        \
		--disable-doxygen-doc	 \
		--disable-doxygen-html 	 \
		--disable-tests 		 \
		--disable-logging 		 \
		--with-plugins="${PREFIX}/share/plugins" \
		--with-boost-extension="-${BOOST_VERSION}"

	sed -i -e "s|\(# This library was specified with -dlpreopen.\)|if [[ \"\${name}\" -eq 'pion' ]]; then name='${PF}'; fi\n\1|" libtool \
		|| die "libtool patch failed"
}

src_install()
{
	default
	doheader include/pion/config.hpp
}
