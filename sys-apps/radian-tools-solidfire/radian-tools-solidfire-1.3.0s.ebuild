# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Radian NVRAM userspace tools"
HOMEPAGE="http://www.radianmemory.com"
SRC_URI="http://bitbucket.org/solidfire/${MY_PN}/get/release/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="Radian-Memory-Systems-Restricted-Use-License"
KEYWORDS="~amd64 amd64"

DEPEND="dev-libs/libnl
	virtual/pkgconfig"
