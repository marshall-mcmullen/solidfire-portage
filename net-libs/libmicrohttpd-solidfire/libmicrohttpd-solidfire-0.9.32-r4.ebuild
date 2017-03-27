# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libmicrohttpd/libmicrohttpd-0.9.32.ebuild,v 1.11 2014/03/01 22:28:57 mgorny Exp $

EAPI="5"
inherit solidfire-libs

DESCRIPTION="A small C library that makes it easy to run an HTTP server as part of another application."
HOMEPAGE="http://www.gnu.org/software/libmicrohttpd/"
EGIT_REPO_URI="https://bitbucket.org/solidfire/${MY_PN}/get/solidfire/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 amd64"

RDEPEND="dev-libs/libgcrypt:0
	net-libs/gnutls"
DEPEND="${RDEPEND}"

# SolidFire Libs Settings
SOLIDFIRE_WANT_EAUTORECONF=1

src_configure()
{
	econf --disable-curl
}
