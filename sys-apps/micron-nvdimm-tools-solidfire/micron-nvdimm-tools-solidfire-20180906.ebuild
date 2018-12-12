# Copyright 2018 NetApp, Inc.  All rights reserved

EAPI=5

inherit solidfire

DESCRIPTION="Micron NVDIMM Diagnostic Tools"
HOMEPAGE="http://www.micron.com"
SRC_URI="http://bitbucket.org/solidfire/${MY_PN}/get/release/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Micron-NDA"
KEYWORDS="amd64"

DEPEND="
    app-misc/jq
    sys-kernel/solidfire-sources
"
RDEPEND=""
RESTRICT="strip"

src_configure()
{ :; }

src_compile()
{
    set -e

    # Build the kernel driver first
    # We need our own private copy of the kernel tree for compilation so we don't cause sandbox violations trying
    # to build directly in /usr/src/linux.
    # NOTE: Need to unset ARCH variable since that is set by ebuild environment (e.g. 'amd64') and conflicts with
    #       automatic architecture detection by kernel module build process.
    unset ARCH
    einfo "Copying /usr/src/linux -> ${S}/kernel"
    mkdir kernel
    cp -a /usr/src/linux/. kernel
    local kernelversion=$(make --no-print-directory -C kernel kernelversion)
    einfo "Building against ${kernelversion}"
    make -C driver KERNELBUILD="${S}/kernel"

    # Build library
    einfo "Building Library"
    sed -i -e "s|||g" \
           -e "s|LIBNAME=.*|LIBNAME=libnvdimm-solidfire-${PV}.so|" \
        library/Makefile
    make -C library

    # Build jedec monitoring utility
    einfo "Building jedec utility"
    sed -i -e "s|||g" \
           -e "s|\(LIBS=.*\)|\1 -L${S}/driver -L${S}/library -Wl,--rpath,${PREFIX}/lib64 -lnvdimm-solidfire-${PV}|" \
        utility/jedec/Makefile
    make -C utility/jedec
}

src_install()
{
    set -e

    # Libraries
    dolib.so "library/libnvdimm-solidfire-${PV}.so"
    dolib "driver/agigaram.ko"
    dolib "driver/imc_smb.ko"
    dolib "driver/jedec_nvdimm.ko"
    dolib "driver/nvdimm_core.ko"
    dolib "driver/nvdimm_mem.ko"
    dolib "driver/nvdimm_smbus.ko"

    # Utility
    dobin "utility/jedec/lsnvdimm"
    dobin "utility/jedec/nvdimm_eeprom"
    dobin "utility/jedec/nvdimm_from20_upgrade"
    dobin "utility/jedec/nvdimm_fwcopy"
    dobin "utility/jedec/nvdimm_log"
    dobin "utility/jedec/nvdimm_regread"
    dobin "utility/jedec/nvdimm_regwrite"
    dobin "utility/jedec/nvdimm_spd"
    dobin "utility/jedec/nvdimm_testmenu"
    dobin "utility/jedec/nvdimm_upgrade"
    dobin "utility/jedec/nvdimm_eeprom"
    dobin "utility/jedec/sfnvdimm_diagnostics"

    # Python scripts for debug logs, needed by nvdimm_log
    dobin "utility/jedec/nvdimm_log.py"
    dobin "utility/jedec/nvdimm_bmct.py"

    # Init
    dobin "etc/init.d/agigaram"
    doservice "${FILESDIR}/agigaram.service"
    
    # Expose bin symlinks outside our application specific directory
    local kernelversion=$(make --no-print-directory -C kernel kernelversion)
    dobinlinks "${DP}"/bin/*
    dopathlinks "/lib/modules/${kernelversion}/kernel/drivers/nvdimm" ${DP}/lib/{agigaram,imc_smb,jedec_nvdimm,nvdimm_core,nvdimm_mem,nvdimm_smbus}.ko
}
