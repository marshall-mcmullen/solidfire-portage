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

src_compile()
{
	cd src
	make
	for binary in $(find . -perm /u=x -type f); do
		local new_name="${PROGRAM_PREFIX}$(basename ${binary})"
		einfo "renaming ${binary} to ${new_name}"
		mv ${binary} ${new_name}
	done
}

src_install()
{
	dobin $(find src -perm /u=x -type f | xargs)
	dobinlinks ${DP}/bin/*
}
