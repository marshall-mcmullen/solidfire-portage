# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire-libs

DESCRIPTION="Radian NVRAM userspace tools"
HOMEPAGE="http://www.radianmemory.com"
SRC_URI="http://bitbucket.org/solidfire/${MY_PN}/get/release/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Radian NDA"
KEYWORDS="~amd64 amd64"

DEPEND='dev-libs/libnl'

SOLIDFIRE_EXPORT_PATH="/sf/packages/${PF}/bin"

src_install()
{
	emake DESTDIR="${D}" install
}
