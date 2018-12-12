# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN=${PN/-bin/}
inherit unpacker eutils

DESCRIPTION="Packer is a tool for creating machine and container images for multiple platforms from a single source configuration"
HOMEPAGE="https://packer.io/"

SRC_URI="https://releases.hashicorp.com/${MY_PN}/${PV}/${MY_PN}_${PV}_linux_amd64.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=$WORKDIR

DEPEND=""
RDEPEND=""

RESTRICT="mirror"

src_install() {
	local dir="/opt/${MY_PN}"
	dodir ${dir}
	cp -ar ./* "${ED}${dir}" || die "copy files failed"

	make_wrapper "${MY_PN}" "${dir}/${MY_PN}"
}
