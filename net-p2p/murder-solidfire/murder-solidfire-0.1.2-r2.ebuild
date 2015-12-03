# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

VTAG="solidfire"
MY_P="${P//-${VTAG}}"
MY_PN="${PN//-${VTAG}}"
MY_PVR="${VTAG}-${PVR}"
S="${WORKDIR}/${MY_P}"

inherit base git-r3

DESCRIPTION="Large scale server deploys using BitTorrent and the BitTornado library"
HOMEPAGE="https://github.com/lg/murder"
EGIT_REPO_URI="${HOMEPAGE}"
EGIT_COMMIT="9c59118ce1"
EGIT_CHECKOUT_DIR=${WORKDIR}/${MY_P}

PATCHES="client_interface_improvements.patch"

LICENSE="Apache-2.0"
KEYWORDS="amd64"
IUSE=""
SLOT=0

DEPEND="
	dev-lang/python:2.7
"

RDEPEND="${DEPEND}"

src_prepare()
{
	base_src_prepare

	echo -n "${PVR}" > VERSION || die

	# The BitTornado included with murder is modified and single-purpose for
	# murder, so call it that, and make sure all of the included scripts can
	# find it.
	mv ${WORKDIR}/${MY_P}/dist/BitTornado ${WORKDIR}/${MY_P}/dist/${MY_PN}
	for f in $(find ${WORKDIR}/${MY_P}/dist -name "*.py") ; do
		sed -i 's|BitTornado|'${MY_PN}'|' ${f} || die
	done
	
	# Make a link to this murder folder in murder-solidfire for those looking
	# for in-house stuff.
	pushd ${WORKDIR}/${MY_P}/dist
	ln -s ${MY_P} ${P}
	popd

	# Rename main murder scripts to have shebang lines and not have .py at the
	# end
	for f in ${WORKDIR}/${MY_P}/dist/*.py ; do
		sed -i '1s|^|#!/usr/bin/env python\n|' ${f} || die
		chmod +x ${f} || die
		mv ${f} ${f%%.py} || die
	done
}

src_install()
{
	einfo "Installing to /usr/lib/python2.7 from ${S}"
	insinto /usr/lib/python2.7
	dobin ${S}/dist/murder_{tracker,client,make_torrent}
	doins -r ${S}/dist/${MY_PN}
}

