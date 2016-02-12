# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Setup variables to upstream source that doesn't have solidfire in it.
MY_P="${P//-solidfire}"
MY_PN="${PN//-solidfire}"
MY_PF="${PF//-solidfire}"
PS="-solidfire-${PVR}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Collection of bash utilities for simpler and more robust bash programming"
HOMEPAGE="http://solidfire.com"
SRC_URI="${MY_PF}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="net-misc/curl
        app-misc/jq
        sys-apps/lsb-release"

RDEPEND="${DEPEND}"

src_install()
{
    DESTDIR=${D}/sf/packages/${P} PV=${PV} ${S}/.forge/install || die

    # Setup backwards compatible symlinks into /usr/local/share/bashutils*
    mkdir -p ${D}/usr/local/share/
    ln -sf /sf/packages/${PN}-solidfire-${PVL} ${D}/usr/local/share/${PF} || die
}
