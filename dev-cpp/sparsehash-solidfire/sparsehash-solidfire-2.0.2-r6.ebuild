# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 versionize

DESCRIPTION="Google's hash-map implementations"
HOMEPAGE="http://code.google.com/p/sparsehash/"
SRC_URI="http://${MY_PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 amd64"

GPERFTOOLS_VERSION="2.1-r1"
DEPEND="=dev-util/gperftools-solidfire-${GPERFTOOLS_VERSION}"
RDEPEND="${DEPEND}"

## PATCHES ##
# 001-memory_fragmentation.patch will disable unittest compilation
# because of fogbugz case 7767, the memory modifications applied
# to the sparsehash allow our BinHash to be copied trivially, but
# break compilation of these unittests.
#
# This also breaks the sparsehash data structure for use with any
# types that are not trivially copyable, though it will all compile
# and run, just memcpy'ing objects blindly, causing run-time weirdness.
PATCHES=(
	"${FILESDIR}/get_num_deleted_keys.patch"
	"${FILESDIR}/001-memory_fragmentation.patch"
	"${FILESDIR}/002-memory_fragmentation.patch"
)

src_configure()
{
	# Include Path
	sed -i -e "s|google/malloc_extension.h|gperftools-solidfire-${GPERFTOOLS_VERSION}/malloc_extension.h|g" \
		   -e "s|\-ltcmalloc|\-ltcmalloc-solidfire-${GPERFTOOLS_VERSION}|g"                                 \
		configure || die

	append-cxxflags "-g -O2"
	versionize_src_configure
}

src_install()
{
	versionize_src_install

	# Include dir has all header files duplicated in 'google' dir. Silly Google. Make legacy backpointer for it.
	rm -rf    "${D}/usr/include/${PF}/google" || die
	doincdir_symlink_self "google"
	
	for f in sparsehash sparsetable type_traits.h; do
		sed -i -e "s|#\(\s*\)include <google/$f|#\1include <sparsehash/$f|g" $(find $(idirv include) -type f) \
			|| die "include path munging failed"
	done
}
