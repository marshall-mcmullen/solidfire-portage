# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="NetApp/SolidFire day zero configuration"
HOMEPAGE="solidfire.com"
SRC_URI="http://sf-artifactory.eng.solidfire.net/sfprime/nde/confrestapp-${PV}.tar -> ${PF}.tar"

LICENSE="SolidFire"
KEYWORDS="amd64"
RESTRICT="strip"
RDEPEND="dev-lang/python:3.5"

src_install()
{
	doins -r ${S}/.

	# EMBER-447: Until we have proper eselect behavior just blindly create the expected symlinks in /sf. We'll manage
	# these better once we have eselect behavior.
	dosym "${PREFIX}/" "/sf/hci/sfprime"
	cp --recursive "${S}/install/." "${D}"

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
	ExecStart=${PREFIX}/confrestapp
	Restart=always

	[Install]
	WantedBy=multi-user.target
	EOF
	cat "${DP}/systemd/sf-nde.service"
}
