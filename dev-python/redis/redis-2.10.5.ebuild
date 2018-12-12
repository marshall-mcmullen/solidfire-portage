# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Ebuild generated by g-pypi 0.4

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1


DESCRIPTION="Python client for Redis key-value store"
HOMEPAGE="http://github.com/andymccurdy/redis-py"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE="test"

DEPEND="dev-python/setuptools"
RDEPEND="dev-python/setuptools
	test? ( >=dev-python/pytest-2.5.0 )"




