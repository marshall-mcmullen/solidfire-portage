# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5

inherit solidfire-libs

DESCRIPTION="NetApp/SolidFire's Networking layer"
HOMEPAGE="https://bitbucket.org/solidfire/ember-network"
SRC_URI="http://bitbucket.com/solidfire/ember-network/get/release/${PV}.tar.bz2 -> ${PF}.tar.bz2"
LICENSE="SolidFire"
KEYWORDS="amd64 ~amd64"

GOOGLE_VERSION="2.0-r1"
DEPEND="
   =dev-cpp/google-libs-solidfire-${GOOGLE_VERSION}
"

RDEPEND="${DEPEND}"

src_prepare()
{
    einfo "Added cflags and ldflags"
    append-cflags "-isystem /sf/packages/google-libs-solidfire-${GOOGLE_VERSION}/include -isystem /sf/packages/google-libs-solidfire-${GOOGLE_VERSION}/include/gflags"
    append-ldflags "-L /sf/packages/google-libs-solidfire-${GOOGLE_VERSION}/lib"

    einfo "Fixing shared/bin/version"
    sed -i "1 a\\echo \"solidfire-${PVR}\"; exit 0" ${S}/shared/bin/version

    einfo "Fixing Makefiles"
    local name
    local list=( $(find ${S} -iname "Makefile" -print) )
    for name in ${list[@]} ; do
        einfo "Changing ${name}"
        sed -i -e "s/-lgflags\>/-lgflags-solidfire-${GOOGLE_VERSION}/g" \
               -e "s/-lglog\>/-lglog-solidfire-${GOOGLE_VERSION}/g"     \
               -e "s/-lgtest\>/-lgtest-solidfire-${GOOGLE_VERSION}/g"     \
               -e "s/-lgmock\>/-lgmock-solidfire-${GOOGLE_VERSION}/g"     \
            ${name}
    done

    einfo "Fixing code differences between versions of Google test"
    sed -i -e 's/gflags::/google::/g' ${S}/daemon/logging.cpp

    solidfire-libs_src_prepare
}
src_install()
{
    emake DESTDIR="${DP}" install
}
