# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit toolchain-funcs solidfire

DESCRIPTION="SolidFire Firmware Collection"
HOMEPAGE="http://www.solidfire.com"
SRC_URI=""

LICENSE="metapackage"
KEYWORDS="~amd64 amd64"
IUSE=""

RDEPEND="
	=sys-firmware/chassis-qs52b-firmware-solidfire-20171127
	=sys-firmware/drives-intel-firmware-solidfire-20171008
	=sys-firmware/drives-samsung-firmware-solidfire-20171008
	=sys-firmware/drives-sandisk-firmware-solidfire-20171008
	=sys-firmware/drives-toshiba-firmware-solidfire-20171008
	=sys-firmware/fchba-qlogic-firmware-solidfire-20171016
	=sys-firmware/hba-lsi-firmware-solidfire-20171008
	=sys-firmware/nic-broadcom-firmware-solidfire-20171008
	=sys-firmware/nic-mellanox-firmware-solidfire-20171008
	=sys-firmware/nvram-marvell-firmware-solidfire-20171008
	=sys-firmware/nvram-radian-firmware-solidfire-20171008
	=sys-firmware/nvram-smart-firmware-solidfire-20171016"

# Need a dummy src_unpack function to create empty ${S} directory to prevent later phases from failing.
src_unpack()
{
	mkdir -p "${S}"
}

src_install()
{
	# Create install directory
	mkdir -p "${DP}/include" "${DP}/lib"

	# Now we need to create some metadata for each package we depend on to allow downstream consumers to symlink and 
	# traverse firmware:
	# (1) Create exports file that will live in ${DP}/exports.sh which lists all the firmware package paths. This
	#     file is suitable to be included by a Makefile or bash script.
	{
		local atom
		local firmwareData=()
		local firmwarePaths=()

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

			# Append firmware paths for later exports
			local firmwareRtfiFolder=$(echo ${data[pf]} | cut -d "-" -f1)
			local firmwareVendor=$(echo ${data[pf]} | cut -d "-" -f2)
			firmwareData+=( ${firmwareRtfiFolder} )
			firmwarePaths+=( "$(echo /sf/packages/${data[pf]}/lib/firmware:/sf/rtfi/firmware/${firmwareRtfiFolder}/${firmwareVendor})" )
		done

		# Export mass list of firmware_rtfi_paths for later parsing in make ember iso. We have a list of "/sf/packages/../:/sf/rtfi/firmware/"
		# that will later be deconstructed with symlinks in the make-ember-iso script"
		echo "export FIRMWARE_RTFI_PATHS=\"$(echo "${firmwareData[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')\""
		echo "export FIRMWARE_PATHS=\"$(echo "${firmwarePaths[@]}")\""
	} | sort > "${DP}/exports.sh"

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
    true
}

