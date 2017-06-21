# Copyright 2017 Solidfire

EAPI=5
inherit solidfire-libs

DESCRIPTION="Radian NVRAM userspace tools"
HOMEPAGE="http://www.radianmemory.com"
SRC_URI="http://bitbucket.org/solidfire/${MY_PN}/get/release/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="Radian NDA"
KEYWORDS="~amd64 amd64"

DEPEND='dev-libs/libnl'
