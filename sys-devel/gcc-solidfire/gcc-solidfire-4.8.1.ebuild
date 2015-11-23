# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-4.8.1-r1.ebuild,v 1.12 2014/09/24 10:29:00 blueness Exp $

EAPI="2"

DESCRIPTION="The GNU Compiler Collection"

LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

## PATCH / CLIBC VERSIONS ##
PATCH_VER="1.2"
UCLIBC_VER="1.0"

## Hardened GCC ##
PIE_VER="0.5.7"
SPECS_VER="0.2.0"
SPECS_GCC_VER="4.4.3"
# arch/libc configurations known to be stable with {PIE,SSP}-by-default
PIE_GLIBC_STABLE="x86 amd64 mips ppc ppc64 arm ia64"
PIE_UCLIBC_STABLE="x86 arm amd64 mips ppc ppc64"
SSP_STABLE="amd64 x86 mips ppc ppc64 arm"
# uclibc need tls and nptl support for SSP support
# uclibc need to be >= 0.9.33
SSP_UCLIBC_STABLE="x86 amd64 mips ppc ppc64 arm"

## VERSIONING ##
inherit eutils toolchain
CTARGET="x86_64-pc-linux-gnu"
PREFIX=/usr
LIBPATH=${PREFIX}/lib/gcc-solidfire/${CTARGET}/${GCC_CONFIG_VER}
INCLUDEPATH=${LIBPATH}/include
BINPATH=${PREFIX}/${CTARGET}/gcc-solidfire-bin/${GCC_CONFIG_VER}
DATAPATH=${PREFIX}/share/gcc-solidfire-data/${CTARGET}/${GCC_CONFIG_VER}
STDCXX_INCDIR=${LIBPATH}/include/g++-v${GCC_BRANCH_VER/\.*/}

EXTRA_ECONF="--libdir=${PREFIX}/lib/gcc-solidfire
			 --libexecdir=${PREFIX}/libexec/gcc-solidfire
			 --with-slibdir=${PREFIX}/lib/gcc-solidfire"

src_prepare() {
	if has_version '<sys-libs/glibc-2.12' ; then
		ewarn "Your host glibc is too old; disabling automatic fortify."
		ewarn "Please rebuild gcc after upgrading to >=glibc-2.12 #362315"
		EPATCH_EXCLUDE+=" 10_all_default-fortify-source.patch"
	fi

	toolchain_src_prepare

	use vanilla && return 0
	#Use -r1 for newer piepatchet that use DRIVER_SELF_SPECS for the hardened specs.
	[[ ${CHOST} == ${CTARGET} ]] && epatch "${FILESDIR}"/gcc-spec-env-r1.patch
}

# We NEVER want to blindly change system compiler to internal SolidFire version
should_we_gcc_config() {
	if [[ ${EBUILD_PHASE} == *"inst" ]] ; then
		einfo "NOT setting SolidFire GCC as system default."
		einfo "If you would like to do so, do the following:"
		einfo "gcc-config ${CTARGET}-${GCC_CONFIG_VER}"
		einfo "source /etc/profile"
		echo
	fi
	return 1
}

## Need to post-process to rename binaries. Can't do it via --program-suffix or it breaks toolchain.eclass
src_install() {
	toolchain_src_install
  
	einfo $(ls ${D}${PREFIX}/bin)
	pushd ${D}${PREFIX}/bin
	for f in $(ls .); do
		mv ${f} ${f/-${GCC_CONFIG_VER}/-solidfire-${GCC_CONFIG_VER}} || die "Failed to rename ${f}"
	done
	popd
}
