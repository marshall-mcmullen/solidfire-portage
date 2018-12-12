# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit solidfire

DESCRIPTION="NetApp Monitoring Agent for VMware"
HOMEPAGE="https://www.solidfire.com"
SRC_URI="https://bitbucket.org/solidfire/hci-monitor/get/release/${PV}.tar.bz2 -> ${PN}-${PV}.tar.bz2"

LICENSE="NetApp"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-python/pyinstaller
	>dev-python/solidfire-sdk-python-1.2
	=dev-python/pyvim-0.0.20
	=dev-python/pyvmomi-6.5
	dev-python/requests
	=dev-python/flask-0.12.2
	=dev-python/werkzeug-0.12.2
	dev-python/flask-cors
	dev-python/configparser
	dev-python/pyopenssl
	=dev-python/psutil-5.2.2
"
RDEPEND="sys-apps/solidfire-sioc"

# Do not strip binaries
RESTRICT="strip"

# Jetty does not like symlinks, and will refuse to let the user change their password if app.properties is one.  
SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=(
    "/sf/packages/sioc/app.properties"
)

src_install()
{
	set -e
	mkdir -p "${DP}"/{,nginx_conf,sioc,systemd,web}
	
	# pyinstaller writes files into /usr/lib64/python3.5 which causes a sandbox violation.
	# 'addpredict' allows pyinstaller to perform this required operation without failing.
	addpredict /usr/lib64/${PYTHON_SINGLE_TARGET/_/.}

	# nma_server hardcodes the path to SIOC but it is different in Ember. So patch things during the build.
	sed -i 's|/opt/solidfire/sioc|/sf/packages/sioc|g' sf/mon/constants.py util/*

	einfo "Running pyinstaller over nma_server.py"
	pyinstaller --noconfirm --clean --onedir   \
		--exclude-module='jinja2.asyncsupport' \
		--exclude-module='jinja2.asyncfilters' \
		"${S}/sf/mon/nma_server.py"

	einfo "Copying static files from source into ${DP}"
	cp --recursive "mnode/nginx_conf/." "${DP}/nginx_conf"
	cp --recursive "mnode/webmgmt/common" "mnode/webmgmt/config" "${DP}/web"
	cp "mnode/sioc/opt/solidfire/sioc/app.properties" "${DP}/sioc"
	chmod 700 "${DP}/sioc/app.properties"

	einfo "Copying pyinstaller created files into ${DP}"
	doins -r "dist/nma_server"
	chmod +x "${DP}/nma_server/nma_server"

	# Setup eselect path so that /sf/hci/nma maps to versioned directory
	dopathlinks "/etc/nginx.legacy.conf.d" "${DP}"/nginx_conf/*
	echo "/sf/hci/nma:${PREFIX}" >> "${D}/${PREFIX}/eselect/symlinks"

	einfo "Copying app.properties over to sioc"
    	mkdir -p ${D}/sf/packages/sioc
    	cp --verbose "${DP}/sioc/app.properties" "${D}/sf/packages/sioc/"
    	chown jetty:jetty "${D}/sf/packages/sioc/app.properties"

	einfo "Creating sf-hci-nma service"
	cp "${FILESDIR}/sf-hci-nma.service" "${DP}/systemd"

	# hci-mnodecfg expects there bo be an empty director at "/sf/hci/nma/conf"
	einfo "Creating empty conf directory"
	mkdir "${DP}/conf"
}

pkg_preinst()
{
    einfo "Removing app.properties from /sf/packages/sioc"
    rm --verbose --force /sf/packages/sioc/app.properties

    solidfire_pkg_preinst
}

