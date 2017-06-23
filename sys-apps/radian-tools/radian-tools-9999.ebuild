# Copyright 2017 Solidfire

EAPI=5
inherit git-r3
inherit solidfire-libs

DESCRIPTION="Radian NVRAM userspace tools"
HOMEPAGE="http://www.radianmemory.com"

# You have to clone the radian-tools repo locally, since it's private
# on bitbucket.  This ebuild tries to clone from:
#     file:///root/radian-tools
EGIT_REPO_URI="file:///root/radian-tools"
EGIT_BRANCH=${SOLIDFIRE_RADIAN_TOOLS_BRANCH:-master}

LICENSE="Radian NDA"
KEYWORDS="~amd64 amd64"

DEPEND='dev-libs/libnl'
