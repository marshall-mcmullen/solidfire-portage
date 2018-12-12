# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire

DESCRIPTION="NetApp/SolidFire day zero configuration"
HOMEPAGE="solidfire.com"
MY_PF="${PF#solidfire-}"
SRC_URI="http://sf-artifactory.eng.solidfire.net/sfprime/nde/${MY_PF}.tar -> ${P}.tar"

LICENSE="SolidFire"
KEYWORDS="amd64"
RESTRICT="strip"
RDEPEND="dev-lang/python:3.5"

src_install()
{
	mkdir -p "${DP}"
	cp --preserve=mode --recursive "${S}/." "${DP}" || die
 	if [[ ! -x "${DP}/confrestapp" ]]; then
		die "${DP}/confrestapp must be executable"
 	fi
	
	# Create eselect symlinks file from template provided in-tree. This overrides the one that is already checked into the source
	# tree due to bugs in the versioning path in the generated eselect file.
	einfo "Generating eselect symlinks file from provided template"
	sed "s|%VERSION%|${PV}|g" "${DP}/install/eselect/symlinks-confrestapp" > "${DP}/eselect/symlinks"
	cat "${DP}/eselect/symlinks"
}
