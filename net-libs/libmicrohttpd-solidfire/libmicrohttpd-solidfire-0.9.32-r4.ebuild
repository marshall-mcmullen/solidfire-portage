# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libmicrohttpd/libmicrohttpd-0.9.32.ebuild,v 1.11 2014/03/01 22:28:57 mgorny Exp $

EAPI="5"
inherit git-r3 solidfire-libs

DESCRIPTION="A small C library that makes it easy to run an HTTP server as part of another application."
HOMEPAGE="http://www.gnu.org/software/libmicrohttpd/"
EGIT_REPO_URI="https://bitbucket.org/solidfire/${MY_PN}.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
EGIT_COMMIT="solidfire/${PVR/-r/-p}"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 amd64"

RDEPEND="dev-libs/libgcrypt:0
	net-libs/gnutls"
DEPEND="${RDEPEND}"

src_configure()
{
	econf --disable-curl
}
