# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_5 )
inherit distutils-r1

DESCRIPTION="A python library for parsing and handling Java .properties files."
HOMEPAGE="https://github.com/Leibniz137/python-jproperties3"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools
        dev-python/pytest-runner"
RDEPEND="${DEPEND}"
