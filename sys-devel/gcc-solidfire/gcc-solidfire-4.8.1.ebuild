# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PATCH_VER="1.2"
UCLIBC_VER="1.0"

# Forcibly set use flags
USE="cxx multilib nls nptl openmp sanitize -fortran -hardened"

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 -amd64-fbsd -x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

# Fully version every solidfire-libs package by setting slot to full package version including
# package revision.
SLOT="${PVR}"

# Setup variables to upstream source that doesn't have solidfire in it.
MY_P="${P//-solidfire}"
MY_PN="${PN//-solidfire}"
S="${WORKDIR}/${MY_P}"
PREFIX="/sf/packages/${P}"
PS="-solidfire-${PVR}"

# The PN matters significantly when inheriting toolchain so temporarily
# set it while inheriting that eclass. It is the unset thereafter.
#inherit solidfire-libs
PN=${MY_PN} inherit eutils toolchain

# Versioning
PREFIX=/sf/packages/${P}
CTARGET=x86_64-pc-linux-gnu
LIBPATH=${PREFIX}/lib
INCLUDEPATH=${PREFIX}/include
BINPATH=${PREFIX}/bin
DATAPATH=${PREFIX}/share/data
STDCXX_INCDIR=${LIBPATH}/include/g++-v${GCC_BRANCH_VER/\.*/}
EXTRA_ECONF="--program-suffix=${PS}"

src_prepare()
{
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
should_we_gcc_config()
{
	return 1
}

# Need to post-process to rename binaries. Can't do it via --program-suffix or it breaks toolchain.eclass
# TODO? Alternative here if this keeps sucking is to remove all the files which start with
# ${CTARGET} and get rid of the symlinks... e.g.:
# 1. Remove all symlinks
# 2. Rename all things to remove CTARGET, e.g. mv ${CTARGET}-g++ g++-solidfire-4.8.1
#
# OR... look at dosym and see if it makes this less painful. 
#
# OR... see why we can't use econf extra args to change program suffix properly...
src_install()
{
	is_crosscompile()
	{
		return 0
	}

	toolchain_src_install
}

src_install_off()
{
	toolchain_src_install
 
	einfo "Versioning binaries"
	local file
	for file in $(find ${D}${PREFIX}/bin -type f -o -type l | sort) ; do

		local suffix="solidfire-${GCC_CONFIG_VER}"
		local dname=$(dirname ${file})
		local fname=$(basename ${file})
		local oname="${fname/-${GCC_CONFIG_VER}}"
		local newfname="${oname}-${suffix}"
		echo "    ${fname} -> ${newfname}"

		# If it's a file, just move it. If it's a symlink to one of the files in this directory
		# then update it.
		if [[ -f "${dname}/${fname}" ]]; then
			mv ${dname}/${fname} ${dname}/${newfname} || die "Failed to rename ${dname}/${fname} -> ${dname}/${newfname}"
		elif [[ -L "${dname}/${fname}" ]]; then
			rm -f ${dname}/${fname} || die "Failed to remove symlink ${dname}/${fname}"
			ln --relative --symbolic ${dname}/${oname}-${suffix} ${dname}/${newfname} || die "Failed to symlink ${dname}/${newfname} -> ${dname}/${oname}-${suffix}"
		fi
	done
}
