# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire

DESCRIPTION="NetApp/SolidFire day zero configuration"
HOMEPAGE="solidfire.com"
SRC_URI="http://sf-artifactory.eng.solidfire.net/sfprime/nde/${UPSTREAM_P}.tar -> ${P}.tar"

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
	
	# Prune directory that we do not want as it's upstart related
	rm -rf "${DP}/install/etc/init"

	# Create eselect symlinks
	dopathlinks "/sf/hci" ${DP}/install/sf/hci/*
	dopathlinks_lstrip "/etc" "${DP}/install/etc/" $(find ${DP}/install/etc -type f)
	echo "/sf/hci/sfprime/confrestapp:${PREFIX}" >> "${D}/${PREFIX}/eselect/symlinks"

	einfo "Creating sf-nde service"
	mkdir "${DP}/systemd"
	cat <<- EOF > "${DP}/systemd/sf-nde.service"
	[Unit]
	Description=NetApp Deployment Engine configuration REST service
	Wants=network.target
	After=network.target

	[Service]
	Type=simple
	User=root
	WorkingDirectory=/sf
	ExecStart=/sf/hci/sfprime/confrestapp/confrestapp
	Restart=always

	[Install]
	WantedBy=multi-user.target
	EOF

	# Remove cruft
	rm -rf "${D}/.keepdir" "${D}/etc/init"
}
