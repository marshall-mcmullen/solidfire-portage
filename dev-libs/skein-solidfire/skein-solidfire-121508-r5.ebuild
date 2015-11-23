# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="Skein hash function family"
HOMEPAGE="http://www.skein-hash.info"
SRC_URI="http://www.skein-hash.info/sites/default/files/skein_NIST_CD_${PV}.zip"

LICENSE="public-domain"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/NIST/CD/Optimized_64bit"

src_prepare()
{
	cp ${FILESDIR}/Makefile . || die
	versionize_src_prepare
}

src_install()
{
	emake LIBDIR="${D}/$(dirv lib)" INCDIR="${D}/$(dirv include)" install || die
	versionize_src_postinst
}
