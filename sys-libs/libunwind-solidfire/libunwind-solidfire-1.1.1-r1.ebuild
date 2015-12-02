# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit solidfire-libs git-r3

DESCRIPTION="Portable and efficient API to determine the call-chain of a program"
HOMEPAGE="http://savannah.nongnu.org/projects/libunwind"
EGIT_REPO_URI="git://git.sv.gnu.org/${MY_PN}"
EGIT_COMMIT="781d5d526361504143e4b19c3e911fc71fca95ba"
EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"

LICENSE="MIT"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND="app-text/texlive-core
	=sys-devel/gcc-solidfire-4.8.1"
RDEPEND=""

PATCHES=( "${FILESDIR}/makefile_disable_fortify_source.patch" )

src_prepare()
{
	eautoreconf
	solidfire-libs_src_prepare
}

src_configure()
{
	econf
	
	sed -i -e "s|\(# This library was specified with -dlpreopen.\)|if [[ \"\${name}\" -eq 'unwind' ]]; then name='unwind${PS}'; fi\n\1|" \
		libtool || die
}
