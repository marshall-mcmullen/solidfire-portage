# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

PROGRAM_PREFIX='radian_'

inherit solidfire

DESCRIPTION="Radian NVRAM userspace tools"
HOMEPAGE="http://www.radianmemory.com"
SRC_URI="http://bitbucket.org/solidfire/${MY_PN}/get/release/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Radian-Memory-Systems-Restricted-Use-License"
KEYWORDS="~amd64 amd64"

DEPEND="dev-libs/libnl
	virtual/pkgconfig"

src_prepare()
{
	sed -i -re 's/(dump_log_page)/radian_\1/' utils/dump_log_page.in
}

src_install()
{
	emake DESTDIR="${D}" install
	dobinlinks ${DP}/bin/*
}
