# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jemalloc/jemalloc-3.6.0.ebuild,v 1.1 2014/05/19 14:09:08 anarchy Exp $

EAPI=5
inherit solidfire-libs

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://www.canonware.com/jemalloc/"
SRC_URI="http://www.canonware.com/download/${MY_PN}/${MY_P}.tar.bz2"

DEPEND="=sys-devel/gcc-solidfire-4.8.1"

LICENSE="BSD"
KEYWORDS="~alpha ~amd64 amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~x86 ~x64-macos"
HTML_DOCS=( doc/jemalloc.html )

src_configure()
{
	append-cflags 						\
		-O3 	  						\
		-march=corei7 					\
		-flto 							\
		-mmmx 							\
		-msse 							\
		-msse2 							\
		-msse3 							\
		-mssse3 						\
		-msse4.1 						\
		-msse4.2 						\
		-mpopcnt 						\
		-mcrc32 						\
		-mlzcnt 						\
		-mmovbe 						\
		-mpclmul 						\
		-minline-stringops-dynamically 	\
		-maccumulate-outgoing-args

	append-ldflags                      \
		-Wl,-O3 						\
		-O3 							\
		-march=corei7 					\
		-flto

	sed -i -e 's|DSO_LDFLAGS=.*|DSO_LDFLAGS="-shared -Wl,-soname,lib'${PF}'.so"|' \
		configure || die "Failed to set soname in configure"
	
	econf                               \
		--disable-valgrind				\
		--disable-fill
}

src_install()
{
	default_src_install
	mv ${DP}/bin/pprof ${DP}/bin/jemalloc-pprof${PS} || die
}
