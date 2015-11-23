# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="gSOAP-based SOAP server/client library"
HOMEPAGE="http://solidfire.com"
SRC_URI="http://192.168.137.1/libs/distfiles/${MY_P}.tar.gz"

LICENSE="gSOAP"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare()
{
	versionize_src_prepare
	
	sed -i -e "s|@CXX@|${CXX}|g"                  			\
		   -e "s|@CXXFLAGS@|${CXXFLAGS}|g"    				\
		   -e "s|@VERSION@|${MY_PVR}|g"       				\
		   -e "s|@DESTDIR_LIB@|${D}$(dirv lib)|g" 		  	\
		   -e "s|@DESTDIR_INCLUDE@|${D}$(dirv include)|g" 	\
	Makefile || die "Failed to set variables in Makefile"
}
