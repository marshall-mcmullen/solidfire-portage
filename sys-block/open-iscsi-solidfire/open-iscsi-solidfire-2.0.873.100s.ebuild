# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit solidfire-libs

DESCRIPTION="Open-iSCSI is a high performance, transport independent, multi-platform implementation of RFC3720"
HOMEPAGE="http://www.open-iscsi.org/"
SRC_URI="https://bitbucket.org/solidfire/open-iscsi/get/solidfire/${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-fs/lsscsi
	sys-apps/util-linux"
S="${WORKDIR}/${MY_P}"

src_prepare()
{
	# Since open-iscsi doesn't use the GNU autotools, we have to go hack the
	# makefile to place the files where we want them.
	sed -i                                              \
		-e "s|DESTDIR ?=|DESTDIR = ${D}|"				\
		-e "s|prefix = /usr|prefix = ${PREFIX}|"		\
		-e "s|exec_prefix = /|exec_prefix = ${PREFIX}|" \
		-e "s|etcdir = /etc|etcdir = ${PREFIX}/etc|"	\
		Makefile || die
}

src_install()
{
	emake DESTDIR="${D}" install
	reparent "${DP}/etc/iscsi"
	rm "${DP}/etc/iscsi"

	# Generate initiator name file
	echo InitiatorName=$(${DP}/sbin/iscsi-iname) > "${DP}/etc/initiatorname.iscsi" || die "Failed to create initiatorname.iscsi"

	# Remove cruft
	rm --recursive --force "${DP}/etc/ifaces"

	# Install a systemd unit file
	cp --recursive "${S}/etc/systemd" "${DP}/etc" || die

	sed -i \
		-e "s|ExecStart=.*|ExecStart=${PREFIX}/sbin/iscsid -c ${PREFIX}/etc/iscsid.conf -i ${PREFIX}/etc/initiatorname.iscsi|" \
		-e "s|ExecStop=/sbin/iscsiadm|ExecStop=${PREFIX}/sbin/iscsiadm|" \
		"${DP}/etc/systemd/iscsid.service" || die
}
