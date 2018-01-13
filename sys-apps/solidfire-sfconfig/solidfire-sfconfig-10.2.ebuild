# Copyright 2017 NetApp. Inc. All rights reserved.

EAPI="5"
inherit mercurial solidfire

DESCRIPTION="SolidFire node configuration daemon"
HOMEPAGE="https://www.solidfire.com"

# Commit message for this version:
# Update neon-patch2 version number to 10.2.0.66.
EHG_REPO_URI="http://hgserve.eng.solidfire.net/hg/neon-patch2"
EHG_REVISION="c8051cd01f06"

# Putting this inside WORKDIR because it complained that /usr/portage/distfiles
# didn't exist and nothing in the emerge process seemed like it would create it
EHG_STORE_DIR=${WORKDIR}/hg_src

LICENSE="SolidFire"
SLOT="0"
KEYWORDS="amd64"

# TODO - should this call out specific versions??
DEPEND="
	dev-libs/solidfire-libs
"
RDEPEND="${DEPEND}"

# don't define src_unpack() - we inherit that from the mercurial eclass which
# uses the EHG_... variables to fetch the source

# the solidfire eclass provides a src_prepare (that we don't need) that also
# sets -std=c++11 and breaks the compile (note: -std=gnu++11 is already on
# for the build - it looks like following that by -std=c++11 turns back off
# GNU extensions and breaks the build)
#
# TODO - the proper way to fix this is to change the element top-level Makefile
#        so that CXXFLAGS from the environment is put first in the line that
#        overrides it (as opposed to towards the end where it's values will
#        still override things from the Makefile)
src_prepare()
{
	true
}

src_compile()
{
	emake CONF=Release sfconfig
}

src_install()
{
	mkdir -p ${DP}/bin
	cp -p ${S}/build/Release/bin/sfconfig ${DP}/bin
	dopathlinks /sf/bin ${DP}/bin/sfconfig

	mkdir -p ${DP}/etc/systemd/system
	cp -p ${S}/install/storage/etc/systemd/system/sfconfig.service ${DP}/etc/systemd/system
	dopathlinks /etc/systemd/system ${DP}/etc/systemd/system/sfconfig.service
}
