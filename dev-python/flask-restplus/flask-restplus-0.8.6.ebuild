# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
# Ebuild generated by g-pypi 0.4

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Fully featured framework for fast, easy and documented API development with Flask"
HOMEPAGE="https://github.com/noirbizarre/flask-restplus"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE="dev doc test"

DEPEND="dev-python/setuptools"
RDEPEND=">=dev-python/aniso8601-0.82
	>=dev-python/flask-0.8
	>=dev-python/six-1.3.0
	dev-python/jsonschema
	dev-python/pytz
	dev-python/setuptools
	dev? ( dev-python/alabaster )
	dev? ( dev-python/blinker )
	dev? ( dev-python/flake8 )
	dev? ( dev-python/invoke )
	dev? ( dev-python/minibench )
	dev? ( dev-python/nose )
	dev? ( dev-python/rednose )
	dev? ( dev-python/sphinx )
	dev? ( dev-python/sphinx-issues )
	dev? ( dev-python/tox )
	dev? ( dev-python/tzlocal )
	doc? ( dev-python/alabaster )
	doc? ( dev-python/sphinx )
	doc? ( dev-python/sphinx-issues )
	test? ( dev-python/blinker )
	test? ( dev-python/mock )
	test? ( dev-python/nose )
	test? ( dev-python/rednose )
	test? ( dev-python/tzlocal )"

PATCHES=( "${FILESDIR}"/distutils_r1-tests-packaging-fix.patch )
