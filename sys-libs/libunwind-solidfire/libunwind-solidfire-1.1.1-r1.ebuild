# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="Portable and efficient API to determine the call-chain of a program"
HOMEPAGE="http://savannah.nongnu.org/projects/libunwind"
SRC_URI="http://download.savannah.gnu.org/releases/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/makefile_disable_fortify_source.patch" )

src_configure()
{
	versionize_src_configure
	sed -i -e "s|# This library was specified with -dlpreopen.|if [[ \"\${name}\" -eq 'unwind' ]]; then name='unwind-${MY_PVR}'; fi\n    # This library was specified with -dlpreopen.|" \
		libtool || die
}
