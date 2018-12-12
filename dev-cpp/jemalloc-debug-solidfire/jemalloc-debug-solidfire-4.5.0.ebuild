# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5
inherit solidfire

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://www.canonware.com/jemalloc/"
SRC_URI="http://www.canonware.com/download/${UPSTREAM_PN//-debug}/${UPSTREAM_P//-debug}.tar.bz2"

DEPEND=""
RDEPEND="${DEPEND}"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"
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
		   -e 's|jemalloc$(install_suffix)|'${PF}'|'                              \
		configure || die "Failed to set soname in configure"
	
	econf		                        \
		--enable-debug                  \
		--enable-fill                   \
		--enable-prof                   \
		--enable-valgrind 
}

src_compile()
{
	sed -i -e 's|LIBJEMALLOC := $(LIBPREFIX)jemalloc$(install_suffix)|LIBJEMALLOC := $(LIBPREFIX)'${PF}'|' Makefile \
		|| die "Failed to set LIBJEMALLOC in Makefile"
	emake
}

src_install()
{
	default

	mv ${DP}/bin/jeprof       ${DP}/bin/jemalloc-debug-pprof || die
	mv ${DP}/bin/jemalloc.sh ${DP}/bin/jemalloc-debug.sh    || die
}
