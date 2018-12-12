# Copyright 2018 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire

DESCRIPTION="NetApp HCI management engine"
HOMEPAGE="solidfire.com"
MY_PF="${PF#solidfire-}"
COMMIT="g9352526"
SRC_URI="http://sf-artifactory.eng.solidfire.net/sfprime/hme/${MY_PF%.*}-${MY_PF##*.}-${COMMIT}.tar -> ${P}.tar"

LICENSE="SolidFire"
KEYWORDS="amd64"
RESTRICT="strip"
RDEPEND="dev-lang/python:3.5"

src_install()
{
	mkdir -p "${DP}"
	cp --preserve=mode --recursive "${S}/." "${DP}" || die
	if [[ ! -x "${DP}/hmerestapp" ]]; then
		die "${DP}/hmerestapp must be executable"
	fi

	# Edit version number in eselect symlinks file provided by hmerestapp to match the actual install location.
	# Only necessary for versions not built off a tag which have the extra -#commits-sha version components
	# that are not valid in Portage's versioning system.
	sed -i "s|solidfire-hmerestapp-[^/]*|solidfire-hmerestapp-${PVR}|g" "${DP}/eselect/symlinks"

	# Remove cruft
	rm -rf "${D}/.keepdir" "${D}/etc/init"
}
