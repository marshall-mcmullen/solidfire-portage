# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )
inherit distutils-r1

DESCRIPTION="Fluent testing for Python"
HOMEPAGE="https://github.com/dave-shawley/fluent-test"
SRC_URI="https://github.com/dave-shawley/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="${DEPEND}
	dev-python/mock"
