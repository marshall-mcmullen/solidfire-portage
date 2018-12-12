# Copyright 2018 NetApp, Inc. All Rights Reserved.

EAPI=6

DESCRIPTION="OpenSSL FIPS Support"
HOMEPAGE="http://solidfire.net"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/libs/distfiles/openssl-fips-${PV}-netapp.tar.gz"

LICENSE="OpenSSL"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
RESTRICT="strip"

S="${WORKDIR}/openssl-fips-${PV}-netapp"

src_compile()
{
	emake -j1
	emake build_tests
}

src_install()
{
	insinto /usr/local/ssl/fips-2.0/lib
	doins fips/fipscanister.o
	doins fips/fipscanister.o.sha1
	doins fips/fips_premain.c
	doins fips/fips_premain.c.sha1

	insinto /usr/include/openssl
	doins fips/*.h
	doins fips/rand/*.h

	insinto /usr/local/ssl/fips-2.0/bin
	insopts -m 755
	doins fips/fipsld
	doins fips/fips_standalone_sha1

	insinto /usr/local/ssl/fips-2.0/test
	insopts -m 755
	doins test/fips_test_suite
}
