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

SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=(
	"/etc/nginx.legacy.conf.d/hci-node.conf"
	"/etc/nginx.cgi-bin/redirect.py"
	"/etc/nginx.server.conf.d/hci-server.conf"
	"/sf/hci/nde_reset.py"
	"/sf/hci/sfprime"
)

src_install()
{
	# To support out of band upgrades, sfprime team wants their code nested another level deep with versioned path so
	# that they can easily drop new versions into place. Specifically, the extract code needs to live at this path:
	# /sf/packages/${PF}/confrestapp-${PV}
	# And have a non-versioned symlink at /sf/packages/${PF}/confrestapp that they can then change to point to other
	# versions.
	doins -r "${S}"
	mv "${DP}/${PF}" "${DP}/confrestapp-${PV}"
	dosym "${PREFIX}/confrestapp-${PV}" "${PREFIX}/confrestapp"

	# EMBER-447: Until we have proper eselect behavior just blindly create the expected symlinks in /sf. We'll manage
	# these better once we have eselect behavior.
	dosym "${PREFIX}/" "/sf/hci/sfprime"
	cp --recursive "${S}/install/." "${D}"

	# Fix nde_reset.py to be a symlink. It was copied in as a flat file from ${S}/install 
	rm "${D}/sf/hci/nde_reset.py"
	dosym "${PREFIX}/confrestapp-${PV}/install/sf/hci/nde_reset.py" "/sf/hci/nde_reset.py"

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
	ExecStart=${PREFIX}/confrestapp/confrestapp
	Restart=always

	[Install]
	WantedBy=multi-user.target
	EOF

	# Remove cruft
	rm -rf "${D}/.keepdir" "${D}/etc/init"
}
