# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

PROGRAM_PREFIX='radian_'

inherit solidfire-libs

DESCRIPTION="Radian NVRAM userspace tools"
HOMEPAGE="http://www.radianmemory.com"
SRC_URI="http://bitbucket.org/solidfire/${MY_PN}/get/release/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Radian NDA"
KEYWORDS="~amd64 amd64"

DEPEND='dev-libs/libnl'

ENVD_FILE="05${PF}"
SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/etc" "/etc/env.d" "/etc/env.d/${ENVD_FILE}" )

src_prepare()
{
	sed -i -re 's/(dump_log_page)/radian_\1/' utils/dump_log_page.in
}

src_install()
{
	emake DESTDIR="${D}" install

	cat > "${T}/${ENVD_FILE}" <<-EOF
	PATH="/sf/packages/${PF}/bin"
	ROOTPATH="/sf/packages/${PF}/bin"
	EOF
	doenvd "${T}/${ENVD_FILE}"
}
