# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="C++ framework for building light weight HTTP interfaces"
HOMEPAGE="https://github.com/cloudmeter/pion"
SRC_URI="pion-5.0.0-ab5e96ea76e676f1f006f0b52a00b371e206e56a.tar.gz"

LICENSE="Boost-1.0"
KEYWORDS="~amd64 amd64"

DEPEND="dev-vcs/git
	=dev-libs/boost-solidfire-1.57.0-r2
	=sys-devel/gcc-solidfire-4.8.1"
RDEPEND="${DEPEND}
	app-arch/bzip2
	dev-libs/openssl
	dev-libs/icu"

LICENSE="Boost-1.0"
REVISION="0"

PATCHES=(
	"${FILESDIR}/certificate_chains.patch"
	"${FILESDIR}/disable_logging.patch"
	"${FILESDIR}/seteuid.patch"
	"${FILESDIR}/thread_naming_support.patch"
	"${FILESDIR}/disable_http_basic_auth_cache.patch"
	"${FILESDIR}/noexcept.patch"
	"${FILESDIR}/boost_units.patch"
	"${FILESDIR}/xss-vulnerability_2.patch"
	"${FILESDIR}/disable_sslv3.patch"
	"${FILESDIR}/mimetypes.patch"
)

S="${WORKDIR}/pion-5.0.0-ab5e96ea76e676f1f006f0b52a00b371e206e56a"

src_prepare()
{
	export AUTOHEADER="/bin/true"
	mkdir m4
	autoreconf -ifs

	solidfire-libs_src_prepare

	# Append boost specific CPP flags
	append-cppflags "-DBOOST_FILESYSTEM_VERSION=3 -DBOOST_NO_CXX11_EXPLICIT_CONVERSION_OPERATORS"
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
