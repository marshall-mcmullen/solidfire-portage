# Copyright 2017-2018 NetApp, Inc. All rights reserved.

if [[ -z ${_SOLIDFIRE_KERNEL_ECLASS} ]]; then
_SOLIDFIRE_KERNEL_ECLASS=1

inherit solidfire kernel-2
EXPORT_FUNCTIONS src_unpack

EAPI="5"
ETYPE="sources"

solidfire-kernel_src_unpack()
{
	solidfire_src_unpack
}

fi
