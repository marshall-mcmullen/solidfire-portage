# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

PROGRAM_PREFIX='radian_'

inherit git-r3
inherit solidfire

DESCRIPTION="Radian NVRAM userspace tools"
HOMEPAGE="http://www.radianmemory.com"

# You have to clone the radian-tools repo locally, since it's private
# on bitbucket.  This ebuild tries to clone from:
#     file:///root/radian-tools
EGIT_REPO_URI="file:///root/radian-tools"
EGIT_BRANCH=${SOLIDFIRE_RADIAN_TOOLS_BRANCH:-solidfire-1.7}

LICENSE="Radian Memory Systems Restricted Use License (1/10/2014)"
KEYWORDS="~amd64"

DEPEND='dev-libs/libnl'

DEPEND="dev-libs/libnl"

src_compile()
{
	cd src
	emake
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
