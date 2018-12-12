# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit solidfire

DESCRIPTION="NetApp HCI - Management Node Configuration Service"
HOMEPAGE="www.netapp.com"
SRC_URI="https://bitbucket.org/solidfire/hci-mnodecfg/get/v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="NetApp"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	app-emulation/open-vm-tools
	=dev-python/certifi-2017.11.5
	=dev-python/chardet-3.0.4
	=dev-python/ddt-1.1.1
	=dev-python/enum34-1.1.6
	=dev-python/future-0.16.0
	=dev-python/idna-2.6
	=dev-python/mock-2.0.0
	=dev-python/pbr-3.1.1
	=dev-python/pycurl-7.43.0.1
	=dev-python/pyhamcrest-1.9.0
	=dev-python/requests-2.18.4
	=dev-python/six-1.11.0
	=dev-python/solidfire-sdk-python-1.4.0.271
	=dev-python/urllib3-1.22"
RDEPEND="${DEPEND}"

src_prepare()
{
	set -e

	# People don't know how Linux shebangs work.
	einfo "Fixing python shebang"
	sed -i 's|#!/usr/bin/env python3.5 -tt|#!/usr/bin/env python3.5|' *.py

	# Scripts incorrectly hard-code path to vmtoolsd
	einfo "Fixing hard-coded vmtoolsd path"
	sed -i 's|/usr/local/bin/vmtoolsd|/usr/bin/vmtoolsd|g' mnodecfg.py
}

src_install()
{
	set -e
	mkdir -p "${DP}"
	cp --preserve=mode --recursive \
		sfprime     \
		mnodecfg.py \
		set_collector_config.py \
		${DP}

	# Create systemd file
	mkdir ${DP}/systemd
	cp "${FILESDIR}/sf-hci-mnodecfg.service" ${DP}/systemd

	# Setup pathlinks
	mkdir "${DP}/eselect"
	echo "/sf/hci/mnodecfg:${PREFIX}" >> "${DP}/eselect/symlinks"
}
