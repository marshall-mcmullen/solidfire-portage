# Copyright 2017 NetApp. Inc. All rights reserved.

EAPI="5"

DESCRIPTION="Manage SolidFire package symlinks"
HOMEPAGE="https://www.solidfire.com"
SRC_URI=""

LICENSE="NetApp"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect"

S="${FILESDIR}"

src_install()
{
	insinto /usr/share/eselect/modules
	newins solidfire-${PV}.eselect solidfire.eselect
}
