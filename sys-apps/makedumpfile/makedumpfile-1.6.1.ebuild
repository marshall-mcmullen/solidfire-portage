# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="A tool to make a compact kdump file."
HOMEPAGE="https://www.sourceforge.net/projects/makedumpfile"
SRC_URI="https://www.sourceforge.net/projects/makedumpfile/files/makedumpfile/${PV}/makedumpfile-${PV}.tar.gz"

PATCHES="
	0001-fixup-install-paths-for-solidfire-libs.patch
"

LICENSE="GPLv2"
KEYWORDS="~amd64 amd64"

#DEPEND='dev-libs/libnl'

ENVD_FILE="05.${PF}"
SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=(
	"/etc"
	"/etc/makedumpfile.conf.sample"
	"/etc/env.d"
	"/etc/env.d/05.${PF}"
)


src_compile()
{
	# This tells the makedumpfile Makefile to not attempt static linking.
	export LINKTYPE="dynamic"
	base_src_compile
}

src_install()
{
	base_src_install

	cat > "${T}/${ENVD_FILE}" <<-EOF
	PATH="/sf/packages/${PF}/sbin"
	ROOTPATH="/sf/packages/${PF}/sbin"
	EOF
	doenvd "${T}/${ENVD_FILE}"
}
