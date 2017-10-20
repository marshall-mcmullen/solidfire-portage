# Copyright 2017 NetApp, Inc.  All rights reserved.

if [[ -z ${_SOLIDFIRE_KERNEL_ECLASS} ]]; then
_SOLIDFIRE_KERNEL_ECLASS=1

inherit solidfire-libs kernel-2
EXPORT_FUNCTIONS src_unpack

EAPI="5"
ETYPE="sources"
detect_version
detect_arch

# Set variables used in ebuild SRC_URI and in src_unpack functions
KVERSION="${PV%.*}"
SFVERSION="${PV##*.}"
SFVERSION="${SFVERSION::-1}"

solidfire-kernel_src_unpack()
{
	# Use solidfire-libs magic unpacking, but then rename unpacked directory so it fits in with kernel-2 eclass naming
	solidfire-libs_src_unpack
	S="${WORKDIR}/linux-${KVERSION}-solidfire${SFVERSION}"
	mv "${MY_S}" "${S}"
}

fi
