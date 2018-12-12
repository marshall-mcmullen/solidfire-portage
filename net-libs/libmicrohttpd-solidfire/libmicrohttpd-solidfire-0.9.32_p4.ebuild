# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI="5"
inherit solidfire

DESCRIPTION="A small C library that makes it easy to run an HTTP server as part of another application."
HOMEPAGE="http://www.gnu.org/software/libmicrohttpd/"
SRC_URI="https://bitbucket.org/solidfire/${UPSTREAM_PN}/get/solidfire/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 amd64"

RDEPEND="dev-libs/libgcrypt:0
	net-libs/gnutls"
DEPEND="${RDEPEND}
	sys-apps/texinfo"

# SolidFire Libs Settings
SOLIDFIRE_WANT_EAUTORECONF=1

src_configure()
{
	econf --disable-curl
}
