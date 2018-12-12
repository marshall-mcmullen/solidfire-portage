# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Skein hash function family"
HOMEPAGE="http://www.skein-hash.info"
SRC_URI="http://www.skein-hash.info/sites/default/files/skein_NIST_CD_${UPSTREAM_PV}.zip"

LICENSE="public-domain"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/NIST/CD/Optimized_64bit"

src_prepare()
{
	cp ${FILESDIR}/Makefile . || die
}

src_install()
{
	emake LIBDIR="${DP}/lib" INCDIR="${DP}/include" install || die
}
