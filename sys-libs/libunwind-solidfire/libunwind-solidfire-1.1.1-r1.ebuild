# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-r3 solidfire-libs

DESCRIPTION="Portable and efficient API to determine the call-chain of a program"
HOMEPAGE="http://savannah.nongnu.org/projects/libunwind"
EGIT_REPO_URI="https://bitbucket.org/solidfire/${MY_PN}.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
EGIT_COMMIT="solidfire/${PVR/-r/-p}"

LICENSE="MIT"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare()
{
	solidfire-libs_src_prepare

	# Disable doc from subdirs to avoid trying to build the documentation since we don't need or want it.
	sed -i -e '/^SUBDIRS/s:doc::' Makefile.in || die
}

src_configure()
{
	econf
	
	sed -i -e "s|\(# This library was specified with -dlpreopen.\)|if [[ \"\${name}\" -eq 'unwind' ]]; then name='unwind${PS}'; fi\n\1|" \
		libtool || die
}
