# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="http://curl.haxx.se/"
SRC_URI="http://curl.haxx.se/download/${UPSTREAM_P}.tar.gz"

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
	sed -i -e "s|-lcurl|-l${P}|g" curl-config.in || die
	solidfire_src_prepare
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
