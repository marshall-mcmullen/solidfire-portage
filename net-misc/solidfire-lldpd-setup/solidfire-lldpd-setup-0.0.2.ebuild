# Copyright 2018 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire

DESCRIPTION="Setup lldpd at boot"
HOMEPAGE="https://bitbucket.org/solidfire/lldpd-setup"
SRC_URI="https://bitbucket.org/solidfire/lldpd-setup/get/${PV}.tgz -> ${P}.tgz"

LICENSE="NetApp"
KEYWORDS="amd64"
IUSE=""

DEPEND="
    net-misc/lldpd
"
RDEPEND="
    ${DEPEND}
"

src_install()
{
    dobin lldpd-setup
    doservice lldpd-setup.service
    doservice lldpd-reconfigure.service
    doservice lldpd-reconfigure.path
    doins lldpd-dhcp-hook.sh
    doins lldpd-override.conf
    dobinlinks "${DP}"/bin/*
    dopathlinks /etc/dhcp/dhclient-exit-hooks.d/ "${DP}"/lldpd-dhcp-hook.sh
    dopathlinks /etc/systemd/system "${DP}"/systemd/*
}
