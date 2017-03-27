# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtest/gtest-1.6.0.ebuild,v 1.10 2012/07/16 12:17:56 blueness Exp $

EAPI=5
inherit solidfire-libs

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="http://curl.haxx.se/"
SRC_URI="http://bitbucket.org/solidfire/${MY_PN}/get/solidfire/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="MIT"
KEYWORDS="amd64 ~amd64"

RDEPEND="app-misc/ca-certificates
	>=net-dns/c-ares-1.10.0
	dev-libs/openssl
	>=net-libs/libssh2-1.4.3
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare()
{
	sed -i -e "s|-lcurl|-l${PF}|g" curl-config.in || die
	solidfire-libs_src_prepare
}

src_configure()
{
	econf                         \
		--enable-ares             \
		--enable-file             \
		--enable-ftp              \
		--enable-http             \
		--enable-largefile        \
		--enable-maintainer-mode  \
		--enable-manual           \
		--enable-nonblocking      \
		--enable-ssl              \
		--disable-dict            \
		--disable-gopher          \
		--disable-gnutls          \
		--without-libidn          \
		--disable-imap            \
		--without-krb4            \
		--without-krb5            \
		--disable-ldap            \
		--without-librtmp         \
		--disable-nss             \
		--disable-pop3            \
		--disable-pop3s           \
		--disable-rtsp            \
		--disable-smtp            \
		--disable-smtps           \
		--without-spnego          \
		--disable-sspi            \
		--disable-telnet          \
		--disable-tftp            \
		--with-libssh2
}
