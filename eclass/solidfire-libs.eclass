# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: root
# Purpose: 
#
if [[ -z ${_SOLIDFIRE_LIBS_ECLASS} ]]; then
_SOLIDFIRE_LIBS_ECLASS=1

inherit base autotools eutils flag-o-matic

EXPORT_FUNCTIONS src_unpack src_prepare pkg_preinst

DEPEND="app-portage/gentoolkit"

# Fully version every solidfire-libs package by setting slot to full package version including
# package revision.
SLOT="${PVR}"

# Setup variables to upstream source that doesn't have solidfire in it.
MY_P="${P//-solidfire}"
MY_PN="${PN//-solidfire}"
MY_PF="${PF//-solidfire}"
PS="-solidfire-${PVR}"
PREFIX="/sf/packages/${PF}"
DP="${D}/${PREFIX}"

# Store off original MY_S incase ebuild modifies S.
MY_S="${WORKDIR}/${MY_P}"
S="${MY_S}"

# Set the directory epatch will look for patches in so we don't have to specify
# it in every ebuild patch line.
EPATCH_SOURCE="${FILESDIR}"

# The caller can set PROGRAM_PREFIX or PROGRAM_SUFFIX to prepend or append given strings to the names of the binaries.
#PROGRAM_PREFIX=""
#PROGRAM_SUFFIX=""

# Global ECONF settings to always pass into econf to ensure proper SolidFire
# directory structures. Yes, we could have a src_configure function but that's
# more invasive and less portable.
EXTRA_ECONF="--prefix=${PREFIX}
		     --bindir=${PREFIX}/bin
		     --sbindir=${PREFIX}/sbin
		     --libexecdir=${PREFIX}/libexec
		     --sysconfdir=${PREFIX}/etc
		     --sharedstatedir=${PREFIX}/com
		     --localstatedir=${PREFIX}/var
		     --libdir=${PREFIX}/lib
		     --includedir=${PREFIX}/include
		     --datarootdir=${PREFIX}/share
		     --datadir=${PREFIX}/share
             --infodir=${PREFIX}/share/info
		     --localedir=${PREFIX}/share/locale
		     --mandir=${PREFIX}/share/man
		     --docdir=${PREFIX}/share/doc
		     --program-prefix=${PROGRAM_PREFIX}
		     --program-suffix=${PROGRAM_SUFFIX}
			 --with-pkgversion=\"SolidFire ${MY_PF}\""

#----------------------------------------------------------------------------------------------------------------------
# VERSIONIZE INSTALL HELPERS
#----------------------------------------------------------------------------------------------------------------------

versionize_soname()
{
	local files_libtool=$(find ${S} -type f \( -name libtool -o -name libtool.m4 -o -name aclocal.m4 -o -name configure \) || die)
	phase "SolidFire libs versioning"

    for fname in ${files_libtool}; do
		einfo "Versioning $(basename ${fname})"
		sed -i -e 's|\(libname_spec\)=["'\'']\+\S\+$|\1="lib\\$name'${PS}'"|g'    \
			   -e 's|\(library_names_spec\)=["'\'']\+\S\+$|\1="\\$libname\.so"|g' \
			   -e 's|\(soname_spec\)=["'\'']\+\S\+$|\1="\\$libname\.so"|g'        \
			${fname} || die
	done

	eend
}

versionize_check()
{
	debug-print-function $FUNCNAME $*

	# Verify all libraries are versioned properly
	phase "SolidFire libs checking versioning"

    # Initial clean-up: Remove all symlinks, all pkgconfig and all *.la files
	{
		find ${DP}/{lib,lib32,lib64}/ -type l -delete
		find ${DP} -type d -name pkgconfig    -exec rm -rf {} \;
		find ${DP} -type f -name *.la         -delete

	} 2>/dev/null

	local file
	for file in $(find ${DP}/{lib,lib32,lib64}/*.{so*,a} -type f 2>/dev/null); do

		# Find basename then find longest .so* or .a* suffix.
		local dname=$(dirname ${file})
		local base=$(basename ${file})
		base="${base%%.so*}"
		base="${base%%.a*}"
		local extension=$(basename ${file})
		extension="${extension:${#base}}"
		local renamed=0
		local version="${PS}"

		# Standardize soname extension
		extension=${extension/.so.*/.so}
		debug-print $FUNCNAME "base=[${base}] ext=[${extension}] version=[${version}]"
		
		# Verify file has expected suffix
		if [[ ${file} != *"${version}${extension}" ]]; then
			local newfile="${dname}/${base//${version}*}${version}${extension}"
			echo -n "   $(basename ${file}) -> $(basename ${newfile})"
			mv "${file}" "${newfile}"
			file=${newfile}
			renamed=1
		fi

		# If it's a shared object also validate the SONAME
		if [[ ${extension} == .so ]]; then
			
			# Add [] around the expected value to match the output from readelf.
			local expected="[$(basename ${file})]"
		
			# Grab real soname via readelf. This has enclosing [] around the SONAME.
			local soname=$(readelf -d ${file} | awk '/SONAME/ {print $5}')
			[[ "${soname}" == "${expected}" ]] || die "SONAME not set properly. Expected '${expected}' and got '${soname}'"

			if [[ ${renamed} -eq 0 ]]; then
				echo -n "   $(basename ${file})"
			fi

			echo " ${expected}"
		
		elif [[ ${renamed} -eq 1 ]]; then
			echo
		fi
		
	done

	# If lib64 exists but no lib create a symlink for easier compatibility
	if [[ -e ${DP}/lib64 && ! -e ${DP}/lib ]]; then
		ln --symbolic --relative ${DP}/lib64 ${DP}/lib
	fi

	# Reparent include and lib directories if needed. For solidfire-libs purposes a directory needs to be reparented 
	# if it is nested twice such as ${PN}/include/${PN}/${PN} -> ${PN}/include/${PN}.
	local dname
	for dname in "${DP}/include" "${DP}/lib"; do
		[[ ! -d "${dname}" ]] && continue

		pushd "${dname}"
		if [[ -d "${MY_PN}" ]]; then
			einfo "Fixing nested '${MY_PN}' in ${dname#${D}/}"
			reparent "${MY_PN}"
		
		# Make a "self pointer" symlink to ourselves for proper -I inclusion by non-versioned name
		elif [[ ! -e "${MY_PN}" ]]; then
			ln -sn . "${MY_PN}" || die "ln . ${MY_PN} failed[1]"
		fi

		popd
	done
}

# Moves all the files in the specified directory up one and then removes that directory. This essentially reparents 
# all the contents of that directory up one in the directory tree.
reparent()
{
	local dname=$1
	[[ -d "${dname}" ]] || die "${dname} is not a directory."

	pushd "${dname}"
	(shopt -s dotglob; mv -- * ..) || die "reparent failed"
	popd
	rmdir "${dname}"    || die "reparent: rmdir ${dname} failed"
	ln -sn . "${dname}" || die "reparent: ln . ${subdir} failed"
}

#----------------------------------------------------------------------------------------------------------------------
# Inject `into` before all of the do* ebuild helper methods to ensure
# code is always installed into the correct application specific package dir.
#----------------------------------------------------------------------------------------------------------------------

# Disable dodoc because we don't need multiple ones for every slotted library
dodoc()
{ :; }

# Inject our own wrapper versions around some key ebuild install functions to ensure
# we install files where we want them.
for cmd in dobin newbin dosbin newsbin doman newman doinfo; do
	eval "${cmd}() { into ${PREFIX}; $(which ${cmd} 2>/dev/null) \$@; }"
done

for cmd in doins newins; do
	eval "${cmd}() { insinto ${PREFIX}; $(which ${cmd} 2>/dev/null) \$@; }"
done

doheader()
{
	insinto "${PREFIX}/include"
	$(which doins 2>/dev/null) "$@"
}

dolib()
{
	insinto "${PREFIX}/lib"
	$(which doins 2>/dev/null) "$@"
}

dolib.so()
{
	into "${PREFIX}"
	$(which dolib.so 2>/dev/null) "$@"
}

dolib.a()
{
	into "${PREFIX}"
	$(which dolib.a 2>/dev/null) "$@"
}

#----------------------------------------------------------------------------------------------------------------------
# SolidFire Libs public ebuild methods
#----------------------------------------------------------------------------------------------------------------------

archive_suffixes()
{
    echo -n ".tar|.tar.gz|.tgz|.taz|.tar.bz2|.tz2|.tbz2|.tbz|.tar.xz|.txz|.tar.lz|.tlz"
}

solidfire-libs_src_unpack()
{
	if [[ -n "${EGIT_REPO_URI}" ]]; then
		git-r3_src_unpack
	elif [[ -n "${EHG_REPO_URI}" ]]; then
		mercurial_src_unpack
	elif [[ -n "${ESVN_REPO_URI}" ]]; then
		svn_src_unpack
	else
		rm --recursive --force --one-file-system "${MY_S}"
		mkdir -p "${MY_S}"
		local srcs=( ${A} )
		
		default_src_unpack

		# Automatically fix our library distfiles to extract to the expected ${WORKDIR}/${MY_P}.
		local fname
		for fname in ${A}; do
			local base="$(shopt -s extglob; echo "${fname%%@($(archive_suffixes))}")"
			local ext="${fname:${#base} + 1}"
			[[ -z "${ext}" ]] && continue
			local tardir=$(tar -tf "${DISTDIR}/${fname}" | head -1 | sed -e 's/\/.*//')
			local sbase=$(basename "${MY_S}")
			local dest="${sbase}"
			if [[ ${#srcs[@]} -gt 1 ]]; then
				dest+="/$(basename ${base})"
			fi
				
			if [[ "${tardir}" != ${dest} ]]; then
				echo "    $(basename "${WORKDIR}/${tardir}") -> ${dest}"
				cp --archive --link "${WORKDIR}/${tardir}/." "${dest}" || die "Failed to mv ${WORKDIR}/${tardir} -> ${dest}"
				rm --recursive --force --one-file-system "${WORKDIR}/${tardir}" || die "Failed to rmdir ${WORKDIR}/${tardir}"
			fi
		done
	fi
}

solidfire-libs_src_prepare()
{
	phase "SolidFire libs prepare"

	# Apply patches
	base_src_prepare

	# If requested run eautoreconf
	if [[ ${SOLIDFIRE_WANT_EAUTORECONF} -eq 1 ]]; then
		eautoreconf
	fi

	# Version our SONAME and then we have to touch all the autoconf related files otherwise later on in the configure
	# and compile proces they get regenerated and clobber our soname versioning.
    versionize_soname
    local fname="" configure_files="configure.ac acinclude.m4 configure.in aclocal.m4 configure config.status config.h.in stamp-h1 Makefile.am aminclude.am Makefile.in Makefile"
    for fname in ${configure_files}; do
        find . -name "*${fname}" -exec touch {} \;
    done

	# Ensure we build any C++ code with newer c++11 standard by default.
	append-cxxflags "-std=c++11"
}

solidfire-libs_pkg_preinst()
{
	# Make sure no files got installed outside ${PREFIX}
	phase "Looking for SolidFire sandbox violations"
	local violations=( $(find ${D} -path ${D}sf/packages -prune -o -path ${D}sf -o -path ${D} -o -print) )

	if [[ ${#SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED[@]} -gt 0 ]]; then
		local idx
		for idx in ${!violations[@]}; do
			local violation=${violations[$idx]}
			local path
			for path in ${SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED[@]}; do
				if [[ "${D%%/}${path}" == ${violation}* ]]; then
					ewarn "Allowing SolidFire sandbox violation ${violation#${D}}"
					unset violations[$idx]
					break
				fi
			done
		done
	fi

	if (( ${#violations[@]} > 0 )); then
		die "SolidFire sandbox violations:\n${violations[@]}"
	fi

	# Verify all headers and libraries are versioned properly
	versionize_check
}

#----------------------------------------------------------------------------------------------------------------------
# MISC HELPERS
#----------------------------------------------------------------------------------------------------------------------

ebanner()
{
	local cols=${COLUMNS:-80}
	cols=$((cols-2))
	eval "local str=\$(printf -- '-%.0s' {1..${cols}})"
	printf "\n+${str}+\n|\n| $@\n|\n+${str}+\n"
}

phase()
{
	tput bold
	tput setaf 2
	echo -en ">>\033[0m "
	echo "$@"
}

pushd()
{
	builtin pushd "${@}" >/dev/null || die "Failed: pushd $@"
}

popd()
{
	builtin popd "${@}" >/dev/null || die "Failed: popd $@"
}

parse_depend_atom()
{
	local input="${1}"
	local output="${2}"

	local tab=$'\t'
	local slot_re='(:[A-Za-z0-9_][A-Za-z0-9+_./-]*)'
	local repo_re='(::[A-Za-z0-9_][A-Za-z0-9_-]*)'                                
	local atom_versioned_re="^([<>]?=)?([^ ${tab}]+-[^ ${tab}/]+|virtual)/([^ ${tab}/?]+)-(([0-9]+)((\.[0-9]+)*)([a-z]?)((_(pre|p|beta|alpha|rc)[0-9]*)*))*(-(r[0-9.]+))?${slot_re}?${repo_re}?$"
	local atom_non_versioned_re="^([^ ${tab}]+-[^ ${tab}/]+|virtual)/([^ ${tab}/?]+)$"

	# Temporary variables for holding values before we copy them out
	local cpn="" cpv="" op="" p="" pn="" pv="" pr="" pvr="" pf="" category="" slot="" subslot=""

	# Versioned atom
	if [[ "${input}" =~ ${atom_versioned_re} ]]; then
		op=${BASH_REMATCH[1]}
		category=${BASH_REMATCH[2]}
		pn=${BASH_REMATCH[3]}
		cpn="${category}/${pn}"
		pv=${BASH_REMATCH[4]}
		p="${pn}-${pv}"
		pr=${BASH_REMATCH[13]:-r0}
		pvr="${BASH_REMATCH[4]}${BASH_REMATCH[12]}"
		pf="${pn}-${pvr}"
		slot=${BASH_REMATCH[14]#:}
		repo=${BASH_REMATCH[15]#::}
		cpv="${category}/${pn}-${pv}"
	elif [[ "${input}" =~ ${atom_non_versioned_re} ]]; then
		op=""
		category=${BASH_REMATCH[1]}
		pn=${BASH_REMATCH[2]}
		cpn="${category}/${pn}"
		p="${pn}"
		pr="r0"
		pf="${pn}"
		cpv="${category}/${pn}"
	else
		die "FAILED TO PARSE ${input}"
	fi

	if [[ "${slot}" == */* ]]; then
         subslot=${slot#*/}
		 slot=${slot%%/*}
	fi

	# Copy everything out
	local var="" val=""
	for var in cpn op p pn pv pr pvr pf category slot subslot; do
		eval "val=\$${var}"
		printf -v ${output}[$var] "${val}"
	done
}

#----------------------------------------------------------------------------------------------------------------------
# END
#----------------------------------------------------------------------------------------------------------------------

fi
