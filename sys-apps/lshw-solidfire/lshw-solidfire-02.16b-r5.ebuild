# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-r3 solidfire-libs

DESCRIPTION="Hardware Lister"
HOMEPAGE="http://ezix.org/project/wiki/HardwareLister"
EGIT_REPO_URI="https://bitbucket.org/solidfire/${MY_PN}.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
EGIT_COMMIT="solidfire/${PVR}"

LICENSE="GPL-2"
KEYWORDS="~amd64 amd64"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_configure()
{
    sed -i -e "s|PREFIX?=/usr|PREFIX=${PREFIX}|"        \
		   -e "s|CXX?=c++|CXX=$(tc-getCXX)|"            \
		   -e "s|CXX=c++|CXX=$(tc-getCXX)|"             \
		   -e "s|LDFLAGS=\(.*\)|LDFLAGS=${LDFLAGS} \1|" \
		{.,core,gui}/Makefile || die "Modifying Makefile failed"
}

src_compile()
{
	emake all
}

src_install()
{
	emake DESTDIR="${D}" PREFIX="${PREFIX}" install
	rm -rf ${D}/share/{lshw,locale} || die
}
