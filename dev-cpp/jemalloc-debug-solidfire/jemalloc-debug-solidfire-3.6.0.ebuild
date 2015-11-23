# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jemalloc/jemalloc-3.6.0.ebuild,v 1.1 2014/05/19 14:09:08 anarchy Exp $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://www.canonware.com/jemalloc/"
SRC_URI="http://www.canonware.com/download/${MY_PN//-debug}/${MY_P//-debug}.tar.bz2"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"
HTML_DOCS=( doc/jemalloc.html )

S="${WORKDIR}/${MY_P//-debug}"

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
	
	versionize_src_configure			\
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
	versionize_src_install

	mv $(idir bin)/pprof-${MY_PVR}       $(idir bin)/jemalloc-debug-pprof-${MY_PVR} || die
	mv $(idir bin)/jemalloc-${MY_PVR}.sh $(idir bin)/jemalloc-debug-${MY_PVR}.sh    || die

	# Remove some directories which collide with non-debug version
	einfo "Removing usr/share"
	rm -rf ${D}/usr/share || die
}
