

# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Portable and efficient API to determine the call-chain of a program"
HOMEPAGE="http://savannah.nongnu.org/projects/libunwind"
SRC_URI="http://bitbucket.org/solidfire/${UPSTREAM_PN}/get/solidfire/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="MIT"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND=""
RDEPEND=""

# SolidFire Libs Settings                                                                                               
SOLIDFIRE_WANT_EAUTORECONF=1

src_prepare()
{
	solidfire_src_prepare

	# Disable doc from subdirs to avoid trying to build the documentation since we don't need or want it.
	sed -i -e '/^SUBDIRS/s:doc::' Makefile.in || die
}

src_configure()
{
	econf
	
	sed -i -e "s|\(# This library was specified with -dlpreopen.\)|if [[ \"\${name}\" -eq 'unwind' ]]; then name='unwind${PS}'; fi\n\1|" \
		libtool || die
}
