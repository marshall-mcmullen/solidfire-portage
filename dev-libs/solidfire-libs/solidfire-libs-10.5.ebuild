# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit toolchain-funcs solidfire

DESCRIPTION="SolidFire 3rd Party Libraries"
HOMEPAGE="http://www.solidfire.com"
SRC_URI=""

LICENSE="metapackage"
SLOT="${PVR}"
KEYWORDS="~amd64 amd64"
IUSE=""

RDEPEND=">=app-misc/jq-1.4
	=app-arch/snappy-solidfire-1.0.4
	=app-text/xml2json-solidfire-1.0-r2
	=app-crypt/libgfshare-solidfire-1.0.5
	=app-emulation/solidfire-vasa-2.9.1
	=dev-cpp/google-libs-solidfire-2.0-r1
	=dev-cpp/jemalloc-debug-solidfire-3.6.0
	=dev-cpp/jemalloc-solidfire-3.6.0
	=dev-cpp/sparsehash-2.0.3
	=dev-cpp/tbb-solidfire-4.3.20141204-r1
	=dev-java/icedtea-bin-3.3.0
	=dev-libs/boost-solidfire-1.57.0-r2
	=dev-libs/crypto++-solidfire-5.6.2-r2
	=dev-libs/jsoncpp-solidfire-0.6.0-r7
	=dev-libs/liblzf-solidfire-3.6-r6
	=dev-libs/skein-solidfire-121508-r6
	=net-analyzer/net-snmp-5.7.3-r5
	=net-dns/c-ares-1.12.0
	=net-libs/libmicrohttpd-solidfire-0.9.32-r4
	=net-misc/curl-solidfire-7.39.0-r1
	net-misc/ntp
	=net-nds/openldap-2.4.44
	sys-apps/dmidecode
	sys-apps/hdparm
	sys-apps/iproute2
	sys-apps/lshw
	=sys-cluster/zookeeper-solidfire-3.5.0-r31
	sys-devel/gdb
	=sys-libs/libunwind-solidfire-1.1.1-r1
	=www-servers/pion-solidfire-5.0.0-r12"

# Need a dummy src_unpack function to create empty ${S} directory to prevent later phases from failing.
src_unpack()
{
	mkdir -p "${S}"
}

src_install()
{
	# Create install directory
	mkdir -p "${DP}/include" "${DP}/lib"

	# Now we need to create some metadata for each package we depend on to allow downstream consumers to compile and 
	# link against this version of solidfire and all of it's explicit dependencies. There are two things we need
	# to setup:
	# (1) Create exports file that will live in ${DP}/exports.sh which lists all the package names and versions. This
	#     file is suitable to be included by a Makefile or bash script. 
	# (2) Create ${DP}/include and ${DP}/lib directories with symlinks out to our dependent packages. This allows
	#     code to simply use "-isystem ${DP}/include" and they will compile against the right versions without having
	#     to version their include paths. This works because we'll create non-versioned symlinks in ${DP}/include.
	{
		echo "export GCC_VERSION=$(gcc-fullversion)"
		echo "export CXX=g++-$(gcc-fullversion)"

		local atom
		for atom in ${RDEPEND}; do
			declare -A data=()
			parse_depend_atom "${atom}" data

			# Skip this package if it doesn't have an explicit version
			if [[ -z "${data[pv]}" ]]; then
				continue
			fi

			# Deteremine package name and version to use for exports
			local pn_export="${data[pn]^^}" pvr_export="${data[pvr]}"
			pn_export="${pn_export//-SOLIDFIRE/}"
			pn_export="${pn_export//SOLIDFIRE-/SF}"
			pn_export="${pn_export//-/}"
			[[ "${data[pn]}" == "crypto++-solidfire" ]] && pn_export="${pn_export/++/PP}"
			[[ "${data[pn]}" =~ "solidfire"          ]] && pvr_export="solidfire-${data[pvr]}"
			echo "export ${pn_export}_VERSION=${pvr_export}"

			# Now create symlinks in ${DP}/include and ${DP}/lib relative to the top of the tree. The reason we use
			# relative symlinks instead of absolute ones is so that the symlinks will resolve properly outside a
			# chroot to make it easier to access header files from outside build containers.
			if [[ "${data[pn]}" =~ "solidfire" ]]; then
				echo "export ${pn_export}_HOME=/sf/packages/${data[pf]}"
				ln --symbolic "../../../../sf/packages/${data[pf]}/include" "${DP}/include/${data[pn]/-solidfire}"
				ln --symbolic "../../../../sf/packages/${data[pf]}/lib"     "${DP}/lib/${data[pn]/-solidfire}"
			fi

			# Munging and convenience operations per-package
			if [[ "${data[pn]}" == "crypto++-solidfire" ]]; then
				ln --symbolic "../../../../sf/packages/${data[pf]}/include" "${DP}/include/cryptopp"
				ln --symbolic "../../../../sf/packages/${data[pf]}/lib"     "${DP}/lib/cryptopp"
			elif [[ "${data[pn]}" == "jsoncpp-solidfire" ]]; then
				ln --symbolic "../../../../sf/packages/${data[pf]}/include" "${DP}/include/json"
				ln --symbolic "../../../../sf/packages/${data[pf]}/lib"     "${DP}/lib/json"
			elif [[ "${data[pn]}" == "google-libs-solidfire" ]]; then
				for module in gflags gtest gmock glog; do
					echo "export ${module^^}_VERSION=${pvr_export}"
					ln --symbolic "../../../../sf/packages/${data[pf]}/include/${module}" "${DP}/include/${module}"
					ln --symbolic "../../../../sf/packages/${data[pf]}/lib/${module}"     "${DP}/lib/${module}"
				done
			elif [[ "${data[pn]}" == "icedtea-bin" ]]; then
				echo "export JAVA_VERSION=${pvr_export}"
				echo "export JAVA_HOME=/opt/icedtea-bin-${pvr_export}"
				echo "export JAVA_EXE=/opt/icedtea-bin-${pvr_export}/bin/java"
			elif [[ "${data[pn]}" == "pion-solidfire" ]]; then
				echo "export PION_PLUGINS_PATH=/sf/packages/${data[pf]}/share/plugins"
			fi	
		done
	} | sort > "${DP}/exports.sh"

	einfo "Created symlinks"
	find "${DP}" -printf "%p -> %l\n" | sed "s|${D}/||"

	einfo "Exports file"
	cat "${DP}/exports.sh"
}

# Disable pkg_preinst so that we do not delete all the non-versioned symlinks we created above in src_install.
pkg_preinst()
{ :; }
