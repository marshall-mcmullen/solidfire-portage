# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://www.canonware.com/jemalloc/"
SRC_URI="http://www.canonware.com/download/${UPSTREAM_PN}/${UPSTREAM_P}.tar.bz2"

DEPEND=""

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
	mv ${DP}/bin/jeprof ${DP}/bin/jemalloc-pprof || die
}
