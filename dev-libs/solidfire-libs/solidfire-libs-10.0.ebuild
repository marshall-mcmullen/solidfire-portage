# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit toolchain-funcs solidfire-libs

DESCRIPTION="SolidFire 3rd Party Libraries"
HOMEPAGE="http://www.solidfire.com"
SRC_URI=""

LICENSE="metapackage"
SLOT="${PVR}"
KEYWORDS="~amd64 amd64"
IUSE=""

RDEPEND=">=app-misc/jq-1.4
	=app-arch/snappy-solidfire-1.0.4
	=app-text/xml2json-solidfire-1.0
	=app-crypt/libgfshare-solidfire-1.0.5
	=dev-cpp/google-libs-solidfire-2.0
	=dev-cpp/jemalloc-debug-solidfire-3.6.0
	=dev-cpp/jemalloc-solidfire-3.6.0
	=dev-cpp/tbb-solidfire-4.3.20141204-r1
	=dev-java/icedtea-bin-7.2.6.8
	=dev-libs/boost-solidfire-1.57.0-r2
	=dev-libs/crypto++-solidfire-5.6.2-r2
	=dev-libs/jsoncpp-solidfire-0.6.0-r7
	=dev-libs/liblzf-solidfire-3.6-r6
	=dev-libs/skein-solidfire-121508-r6
	>=net-dns/c-ares-1.10.0
	=net-libs/libmicrohttpd-solidfire-0.9.32-r4
	=net-misc/curl-solidfire-7.39.0-r1
	sys-apps/dmidecode
	>=sys-apps/hdparm-9.43
	sys-apps/iproute2
	=sys-apps/lshw-solidfire-02.16b-r5
	=sys-cluster/zookeeper-solidfire-3.5.0-r30
	>=sys-devel/gdb-7.6.2
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
	# link against this version of solidfire-libs and all of it's explicit dependencies. There are two things we need
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

			local pn="${data[pn]^^}"
			pn="${pn//-SOLIDFIRE/}"
			pn="${pn//-/}"
			echo "export ${pn}_VERSION=${data[pvr]}"

			# If this package is zookeeper we also need to lookup what version of java it depends on.
			if [[ "${data[pn]}" == "zookeeper-solidfire" ]]; then
				echo "export ZOOKEEPER_HOME=/sf/packages/${data[pf]}"
				local javav=$(grep -Po "=dev-java/icedtea-bin\K\S*" "/var/db/pkg/${data[category]}/${data[pf]}/DEPEND")
				echo "export JAVA_EXE=/opt/icedtea-bin-${javav}/bin/javac"
			fi

			# Now create **relative** symlinks in ${DP}/include and ${DP}/lib. The reason we use relative symlinks 
			# instead of absolute ones is so that the symlinks will resolve properly outside a chroot to make it easier
			# to access header files from outside build containers.
			ln --symbolic "../../../../sf/packages/${data[pf]}/include" "${DP}/include/${data[pn]/-solidfire}"
			ln --symbolic "../../../../sf/packages/${data[pf]}/lib"     "${DP}/lib/${data[pn]/-solidfire}"

		done
	} | sort > "${DP}/exports.sh"

	einfo "Created symlinks"
	find "${DP}" -printf "%p -> %l\n" | sed "s|${D}/||"

	einfo "Exports file"
	cat "${DP}/exports.sh"
}

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
