# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit toolchain-funcs solidfire-libs

DESCRIPTION="SolidFire Firmware Collection"
HOMEPAGE="http://www.solidfire.com"
SRC_URI=""

LICENSE="metapackage"
SLOT="${PVR}"
KEYWORDS="~amd64 amd64"
IUSE=""

RDEPEND="
	=sys-firmware/chassis-qs52b-firmware-solidfire-20171008
	=sys-firmware/drive-intel-firmware-solidfire-20171008
	=sys-firmware/drive-samsung-firmware-solidfire-20171008
	=sys-firmware/drive-sandisk-firmware-solidfire-20171008
	=sys-firmware/drive-toshiba-firmware-solidfire-20171008
	=sys-firmware/hba-lsi-firmware-solidfire-20171008
	=sys-firmware/nic-broadcom-firmware-solidfire-20171008
	=sys-firmware/nic-mellanox-firmware-solidfire-20171008
	=sys-firmware/nvram-marvell-firmware-solidfire-20171008
	=sys-firmware/nvram-radian-firmware-solidfire-20171008
	=sys-firmware/nvram-smart-firmware-solidfire-20171008"

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
	# link against this version of solidfire-libs and all of it's explicit dependencies. There are two things we need
	# to setup:
	# (1) Create exports file that will live in ${DP}/exports.sh which lists all the package names and versions. This
	#     file is suitable to be included by a Makefile or bash script. 
	# (2) Create ${DP}/include and ${DP}/lib directories with symlinks out to our dependent packages. This allows
	#     code to simply use "-isystem ${DP}/include" and they will compile against the right versions without having
	#     to version their include paths. This works because we'll create non-versioned symlinks in ${DP}/include.
	{
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

# Helper function for testing
verify()
{
	local input="$1"; shift
	einfo "Testing ${input}"
	declare -A data=()
	parse_depend_atom "${input}" data

	local entry
	for entry in ${@}; do
		local key=${entry%%=*}
		local expect=${entry#*=}
		local actual=${data[$key]}
		[[ "${expect}" == "${actual}" ]] || die "Op=\"${key}\" Expected=\"${expect}\" Actual=\"${actual}\""
		printf '   - Op:%-10s Expected:%-30s Actual:%s\n' "${key}" "${expect}" "${actual}"
	done
}

# Test parse_depend_atom for correctness.
src_test()
{
	verify "=app-text/snappy-solidfire-1.0.1" \
		op="="						\
		category="app-text"			\
		pf="snappy-solidfire-1.0.1" \
		p="snappy-solidfire-1.0.1"	\
		pn="snappy-solidfire"		\
		pv="1.0.1"					\
		pr="r0"						\
		pvr="1.0.1"

	verify ">=dev-cpp/tbb-solidfire-4.3.20141204-r1" \
		op=">="				    			\
		category="dev-cpp"	                \
		pf="tbb-solidfire-4.3.20141204-r1"	\
		p="tbb-solidfire-4.3.20141204"		\
		pn="tbb-solidfire"					\
		pv="4.3.20141204"					\
		pr="r1"								\
		pvr="4.3.20141204-r1"

	verify "<=dev-libs/crypto++-solidfire-5.6.2-r2" \
		op="<="				    			\
		category="dev-libs"	                \
		pf="crypto++-solidfire-5.6.2-r2"	\
		p="crypto++-solidfire-5.6.2"        \
		pn="crypto++-solidfire"             \
		pr="r2"								\
		pvr="5.6.2-r2"

	verify "=net-misc/curl-solidfire-7.39.0_pre40-r202" \
		op="="								  \
		category="net-misc"					  \
		pf="curl-solidfire-7.39.0_pre40-r202" \
		p="curl-solidfire-7.39.0_pre40"       \
		pn="curl-solidfire"                   \
		pr="r202"                             \
		pvr="7.39.0_pre40-r202"

	verify "=net-misc/curl-solidfire-7.39.0_pre40-r202:10" \
		op="="								  \
		category="net-misc"					  \
		pf="curl-solidfire-7.39.0_pre40-r202" \
		p="curl-solidfire-7.39.0_pre40"       \
		pn="curl-solidfire"                   \
		pr="r202"                             \
		pvr="7.39.0_pre40-r202"               \
		slot="10"

	verify "=net-misc/curl-solidfire-7.39.0_pre40-r202:10/1" \
		op="="								  \
		category="net-misc"					  \
		pf="curl-solidfire-7.39.0_pre40-r202" \
		p="curl-solidfire-7.39.0_pre40"       \
		pn="curl-solidfire"                   \
		pr="r202"                             \
		pvr="7.39.0_pre40-r202"               \
		slot="10"                             \
		subslot=1

	verify "sys-apps/dmidecode"               \
		op=""                                 \
		category="sys-apps"                   \
		pf="dmidecode"                        \
		p="dmidecode"                         \
		pn="dmidecode"                        \
		pr="r0"                               \
		pvr=""                                \
		slot=""
}

