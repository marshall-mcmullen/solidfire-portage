# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: root
# Purpose: 
#

if [[ ${___ECLASS_ONCE_VERSIONIZE} != "recur -_+^+_- spank" ]] ; then
___ECLASS_ONCE_VERSIONIZE="recur -_+^+_- spank"

inherit base autotools eutils flag-o-matic alternatives

EXPORT_FUNCTIONS src_prepare src_configure src_install src_postinst pkg_postinst pkg_postrm

DEPEND="app-portage/gentoolkit"

## DEFAULTS ##
: ${VSTRICT:=1}
: ${VSONAME:=1}
: ${VPYTHON:=1}

SLOT="${PVR}"
if [[ -n ${VTAG} ]]; then
    MY_P="${P//-${VTAG}}"
    MY_PN="${PN//-${VTAG}}"
    MY_PVR="${VTAG}-${PVR}"
    S="${WORKDIR}/${MY_P}"
else
    MY_P="${P}"
    MY_PN="${PN}"
    MY_PVR="-${PVR}"
fi

## DIRECTORY VARIABLES ##
DMERGE="/usr/local"
DBASE=${S}
DROOT="${S}${DMERGE}"
DBIN="${DROOT}/bin"
DSBIN="${DROOT}/sbin"
DLIBEXEC="${DROOT}/libexec"
DCOM="${DROOT}/com"
DLIB="${DROOT}/lib"
DINC="${DROOT}/include"
DSHARE="${DROOT}/share"
DMAN="${DSHARE}/man"
DETC="${DBASE}/etc"
DOPT="${DBASE}/opt"
DVAR="${DBASE}/var"

#-----------------------------------------------------------------------------
# DIRECTORY VERSIONING HELPERS
#-----------------------------------------------------------------------------
dirv()
{
    [[ ${1} == "etc" || ${1} == "opt" || ${1} == "var" ]] && { echo -n "/${1}/${PF}";    return; }
    [[ ${1} == "bin" || ${1} == "sbin" ]]                 && { echo -n "${DMERGE}/${1}"; return; }
    echo -n "${DMERGE}/${1}/${PF}"
}

dir()
{
    [[ ${1} == "var" ]]                  && { echo -n "/${1}" ;      return; }
    [[ ${1} == "etc" || ${1} == "opt" ]] && { echo -n "/${1}/${PN}"; return; }
    echo -n "${DMERGE}/${1}"
}

idirv()
{
    echo -n "${D}/$(dirv ${1})"
}

idir()
{
    echo -n "${D}/$(dir ${1})"
}

# Reparent all files/directories in a given directory to that directory's parent.
doparent()
{
    [[ -d ${1} ]]       || return
    mv ${1}/* ${1}/..   || die "doparent failed"
    rmdir ${1}          || die "doparent failed"
}

#-----------------------------------------------------------------------------
# VERSIONIZE INSTALL HELPERS
#-----------------------------------------------------------------------------
doversion_soname_sed()
{
    local fname=$1; [[ -z ${fname} ]] && die

    ## ESCAPED ##
    sed -i -e "s|libname_spec=\(['\"]\)lib\\\\\$name['\"]|libname_spec_ebuild=\1lib\\\\\$name-${MY_PVR}\1|g"     ${fname} || die
    sed -i -e "s|library_names_spec=\(['\"]\).*\\\\\${libname}.*['\"]|library_names_spec_ebuild=\1\\\\\${libname}\.so\1|g" ${fname} || die
    sed -i -e "s|soname_spec=\(['\"]\).*\\\\\${libname}.*['\"]|soname_spec_ebuild=\1\\\\\${libname}\.so\1|g"               ${fname} || die

    ## NON ESCAPED ##
    sed -i -e "s|libname_spec=\(['\"]\)lib\\\$name['\"]|libname_spec_ebuild=\1lib\\\$name-${MY_PVR}\1|g"     ${fname} || die
    sed -i -e "s|library_names_spec=\(['\"]\).*\\\${libname}.*['\"]|library_names_spec_ebuild=\1\\\${libname}\.so\1|g" ${fname} || die
    sed -i -e "s|soname_spec=\(['\"]\).*\\\${libname}.*['\"]|soname_spec_ebuild=\1\\\${libname}\.so\1|g"               ${fname} || die

    ## STRIP _ebuild TAG
    sed -i -e "s|\(.*\)_ebuild=\(.*\)|\1=\2|g" ${fname} || die
}

doversion_soname()
{
    [[ ${VSTRICT} -eq 0 ]] && return
    [[ ${VSONAME} -eq 0 ]] && return
    
    local files_libtool=$(find ${S} -name "libtool" -o -name "libtool.m4" -o -name "aclocal.m4" -o -name "configure")
    [[ -n ${files_libtool} ]] || return

    pushd ${S}/${S_BUILD} >/dev/null

    einfo "Versioning libtool [libname_spec, library_names_spec, soname_spec]"

    for fname in ${files_libtool}; do
        echo "   -- $(basename ${fname})"
        doversion_soname_sed ${fname}
    done

    popd >/dev/null
}

doversion_soname_verify()
{
    [[ ${VSTRICT} -eq 0 ]] && return
    [[ ${VSONAME} -eq 0 ]] && return

    ## CHECK SONAME ##
    local target=$1

    ## It might not be a valid ELF file.
    readelf -d ${target} &>/dev/null || return

    local soname=$(readelf -d ${target} | grep --color=never SONAME | awk '{print $5}')
    [[ "${soname}" == "[${target}]" ]] || die "SONAME not set properly. Expected '${target}' and got '${soname}'" 
}

doversion_libs()
{
    pushd ${D}$(dirv lib) >/dev/null 2>&1 || return

    einfo "Versioning libraries"

    # Lib dir is versioned, so doparent contents (if necessary)
    local name="$(/bin/ls)"
    local ncontents=$(/bin/ls | wc -l)
    if [[ -d "${name}" ]] && [[ $ncontents -eq 1 ]] ; then
        echo "   -- Fixing nested '${name}'"
        doparent "${name}"

        # make a symlink to ourselves for proper -I inclusion by non-versioned name (if we can)
        local link="${PN/-${VTAG}}"
        [[ ! -e ${link} ]] && (ln -sn . ${link} || die "ln . ${link} failed[1]")
        [[ ! -e ${name} && ${name} != ${PN} && ${name} != ${link} ]] && (ln -sn . ${name} || die "ln . ${name} failed[2]")
    fi

    [[ ${VSTRICT} -eq 0 ]] && { popd >/dev/null; return; }
    
    ## INITIAL CLEAN UP
    rm -rf "pkgconfig" || die
    find . -type l -delete || die "Failed to remove symlinks"
    
    exts=( "a" "la" "so" )
    for ext in "${exts[@]}"; do
        cmd="files=\"$(/bin/ls *.${ext}* 2>/dev/null)\""
        eval ${cmd}
        for f in ${files}; do
            local myext=$(echo ${f} | grep --color=never -o "\.${ext}.*")
            local base=$(echo ${f} | sed -e "s|\(.*\)${myext}|\1|")
            local version=$(echo ${base} | grep --color=never -o "\-[0-9]\+")
            local fname=$(echo ${base} | sed -e "s|\(.*\)${version}.*|\1|")
            if [[ "${fname: -1}" == "-" || "${fname}: -1}" == "." ]]; then
                fname=${fname%-}
            fi    

            target="${fname}-${MY_PVR}.${ext}"
            target="${target//${VTAG}-${MY_PVR}/${MY_PVR}}"

            if [[ "${f}" != "${target}" ]]; then
                echo "   -- ${f} => ${target}"
                eval "mv ${f} ${target} || die"
            fi

            if [[ "${ext}" == "so" ]]; then
                ## ADJUST *.la file (if exists) ##
                lafile="${fname}-${PVR}.la"
                if [[ -f "${lafile}" ]]; then
                    echo "   -- Fixing ${lafile}"
                    sed -i -e "s|dlname=.*|dlname='${target}'|" ${lafile} || die
                    sed -i -e "s|library_names=.*|library_names='${target}'|" ${lafile} || die
                fi

                doversion_soname_verify ${target}
            fi
        done
    done

    popd >/dev/null
}

doversion_bins()
{
    einfo "Versioning binaries [${MY_PVR}]"
   
    for d in ${D}/${DMERGE}/bin ${D}/${DMERGE}/sbin; do
        pushd ${d} &>/dev/null || continue
        files=$(/bin/ls * 2>/dev/null)
        [[ -z ${files} ]] && return

        for f in ${files}; do 
            [[ ${f} =~ .*-(${MY_PVR}) ]] && continue
            local ext=""
            local base="${f}"
            [[ ${f} =~ \. ]] && { ext=".${f##*.}"; base="${f%.*}"; }

            echo "   -- ${f} => ${base}-${MY_PVR}${ext}"
            mv ${f} ${base}-${MY_PVR}${ext} || die
        done

        popd >/dev/null

    done
}

doversion_man()
{
    einfo "Versioning man pages [${MY_PVR}]"
    
    for d in ${D}/${DMERGE}/share/man; do
        pushd ${d} &>/dev/null || continue

        files=$(find . -type f 2>/dev/null)
        [[ -z ${files} ]] && return

        for f in ${files}; do 
            [[ ${f} =~ .*-(${MY_PVR}) ]] && continue
            local ext="${f##*.}"
            local base="${f%.*}"

            echo "   -- ${f} => ${base}-${MY_PVR}.${ext}"
            mv ${f} ${base}-${MY_PVR}.${ext} || die
        done

        popd >/dev/null

    done
}

doincdir_symlink_self()
{
    pushd ${D}$(dirv include) >/dev/null
    local name=$1
    [[ -z ${name} ]] && name="${PN/-${VTAG}}"

    ln -sn . ${name} || die "ln . ${name} failed"

    popd >/dev/null
}

doversion_includes()
{
    pushd ${D}$(dirv include) &>/dev/null || return

    einfo "Versioning includes"

    # Include dir is versioned, so doparent contents (if necessary)
    local name="$(/bin/ls)"
    local ncontents=$(/bin/ls | wc -l)
    if [[ -d "${name}" ]] && [[ $ncontents -eq 1 ]] ; then
        echo "   -- Fixing nested '${name}'"
        doparent "${name}"
        doincdir_symlink_self
    else
        name="${PN/-${VTAG}}"
        if [[ -d ${name} ]]; then
            echo "   -- Fixing nexted '${name}'"
            doparent ${name}
        fi

        doincdir_symlink_self
    fi
    
    popd >/dev/null
}

#-----------------------------------------------------------------------------
# PUBLIC EBUILD METHODS
#-----------------------------------------------------------------------------

versionize_src_prepare()
{
    base_src_prepare
}

versionize_src_configure()
{
    [[ -f configure ]] || return

    einfo "Versionize src_configure"

    [[ -f Makefile.in ]] && sed -i -e "s|^docdir\s*=.*|docdir = @docdir@|g" Makefile.in

    econf                                   \
        --prefix="${DMERGE}"                 \
        --bindir="$(dirv bin)"              \
        --sbindir="$(dirv sbin)"            \
        --libexecdir="$(dirv libexec)"      \
        --sysconfdir="$(dirv etc)"          \
        --sharedstatedir="$(dirv com)"      \
        --localstatedir="$(dirv var)"       \
        --libdir="$(dirv lib)"              \
        --includedir="$(dirv include)"      \
        --datarootdir="$(dirv share)"       \
        --datadir="$(dirv share)"           \
        --infodir="$(dirv share/info)"      \
        --localedir="$(dirv share/locale)"  \
        --mandir="$(dir share/man)"         \
        --docdir="$(dirv share/doc)"        \
        --program-suffix="-${MY_PVR}"       \
        "$@"                                \

    doversion_soname

    local configure_files="configure.ac acinclude.m4 configure.in aclocal.m4 configure config.status config.h.in stamp-h1 Makefile.am aminclude.am Makefile.in Makefile"

    for f in ${configure_files}; do
        find . -name "*$f" -exec touch {} \;
    done

    ## THIS IS A LAST-DITCH EFFORT TO ABSOLUTELY PREVENT ANY OF THE DAMN AUTO TOOLS FROM
    ## RE-RUNNING BY TURNING THEM INTO ECHOS :-).
    makefiles=$(find . -name "Makefile")
    for m in ${makefiles}; do 
        for t in ACLOCAL AUTOCONF AUTOHEADER AUTOMAKE; do
            sed -i -e "s|$t = \(.*\)|$t = echo \1|" ${m}
        done
    done
}

versionize_src_install()
{
    default
    versionize_src_postinst
}

versionize_src_postinst()
{
    echo ">>> Performing post src_install versioning"
    doversion_includes
    doversion_libs
    doversion_bins
    doversion_man
}

versionize_alternatives()
{
    # Include / Lib
    alternatives_makesym "${DMERGE}/include/${PN}" $(find ${DMERGE}/include/${PN}-* -maxdepth 0 2>/dev/null | sort -rV)
    alternatives_makesym "${DMERGE}/lib/${PN}"     $(find ${DMERGE}/lib/${PN}-*     -maxdepth 0 2>/dev/null | sort -rV)
    alternatives_makesym "${DMERGE}/share/${PN}"   $(find ${DMERGE}/share/${PN}-*   -maxdepth 0 2>/dev/null | sort -rV)    
    for d in include lib share; do
        [[ -e ${DMERGE}/${d}/${PN} ]] || continue
        ln -sf "${DMERGE}/${d}/${PN}" "${DMERGE}/${d}/${MY_PN}"
    done

    # Binaries
    for f in $(equery f ${PF} | egrep "^(${DMERGE}/bin|${DMERGE}/sbin)"); do
        alternatives_makesym ${f/-${PVR}*} $(find ${f/-${PVR}*}-* -maxdepth 0 2>/dev/null | sort -rV)
    done
}

versionize_pkg_postinst()
{
    echo ">>> Updating Alternatives [pkg_postinst]"
    versionize_alternatives
}

versionize_pkg_postrm()
{
    echo ">>> Updating Alternatives [pkg_postrm]"
    versionize_alternatives
}

fi
