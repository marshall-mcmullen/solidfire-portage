# Copyright 2017 NetApp, Inc.  All rights reserved.

if [[ -z ${_SOLIDFIRE_KERNEL_ECLASS} ]]; then
_SOLIDFIRE_KERNEL_ECLASS=1

inherit solidfire kernel-2
EXPORT_FUNCTIONS src_unpack

EAPI="5"
ETYPE="sources"

# Set variables used in ebuild SRC_URI and in src_unpack functions
KVERSION="${PV%.*}"
SFVERSION="${PV##*.}"
SFVERSION="${SFVERSION::-1}"
KV_FULL="${KVERSION}-solidfire${SFVERSION}"
S="${WORKDIR}/linux-${KV_FULL}"

solidfire-kernel_src_unpack()
{
	# Use solidfire magic unpacking, but then rename unpacked directory so it fits in with kernel-2 eclass naming
	solidfire_src_unpack
	mv "${MY_S}" "${S}"
}

fi
