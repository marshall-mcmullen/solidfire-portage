# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="SolidFire Python SDK"
HOMEPAGE="https://github.com/solidfire/solidfire-sdk-python"
SRC_URI="https://github.com/solidfire/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
SLOT="0"
IUSE="dev docs examples release test"

DEPEND="dev-python/setuptools"
RDEPEND=">=dev-python/enum34-1.1.6
	>=dev-python/future-0.15.2
	>=dev-python/requests-2.9.1
	dev-python/setuptools
	dev? ( dev-python/check-manifest )
	docs? (
		>=dev-python/sphinx-1.3.5 
		>=dev-python/sphinx-rtd-theme-0.1.9
	)
	release? ( >=dev-python/twine-1.6.5 )
	test? (
		>=dev-python/pyhamcrest-1.8.5
		>=dev-python/pytest-2.8.7
		>=dev-python/pytest-flake8-0.1
		dev-python/coverage
	)"

DOCS=docs

EXAMPLES=examples
