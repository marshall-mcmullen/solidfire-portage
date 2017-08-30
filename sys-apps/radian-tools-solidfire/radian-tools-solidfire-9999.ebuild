# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

PROGRAM_PREFIX='radian_'

inherit git-r3
inherit solidfire-libs

DESCRIPTION="Radian NVRAM userspace tools"
HOMEPAGE="http://www.radianmemory.com"

# You have to clone the radian-tools repo locally, since it's private
# on bitbucket.  This ebuild tries to clone from:
#     file:///root/radian-tools
EGIT_REPO_URI="file:///root/radian-tools"
EGIT_BRANCH=${SOLIDFIRE_RADIAN_TOOLS_BRANCH:-solidfire-1.3}

LICENSE="Radian NDA"
KEYWORDS="~amd64"

DEPEND='dev-libs/libnl'

SOLIDFIRE_EXPORT_PATH="/sf/packages/${PF}/bin"

src_prepare()
{
	sed -i -re 's/(dump_log_page)/radian_\1/' utils/dump_log_page.in
}

src_install()
{
	emake DESTDIR="${D}" install
}
