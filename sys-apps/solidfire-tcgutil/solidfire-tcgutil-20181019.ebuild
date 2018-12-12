# Copyright 2018 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Solidfire TCG Opal tool"
HOMEPAGE="https://bitbucket.org/solidfire/tcgutil"

dir_name=${PN#solidfire-}
SRC_URI="https://bitbucket.org/solidfire/${dir_name}/get/release/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="NetApp"
KEYWORDS="amd64"

DEPEND="
    sys-kernel/solidfire-sources
"
RDEPEND=""

src_configure()
{
    set -e
    ./configure
}

src_compile()
{
    set -e
    make
}

src_install()
{
    set -e

    # adds the tcgutil file to the package in /sf/packages/tcgutil/bin
    dobin "tcgutil"

    # adds a link in /usr/bin to tcgutil in the /sf/packages/tcgutil/bin
    dobinlinks "${DP}"/bin/*
}
