# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit mercurial java-pkg-2 solidfire-libs

DESCRIPTION="SolidFire VASA (vSphere API for Storage Awareness) Provider"
HOMEPAGE="http://solidfire.com"
EHG_REPO_URI="http://hgserve.eng.solidfire.net/hg/vasa-plugin"
EHG_REVISION="e95487c3fb7a"

LICENSE="SolidFire"
KEYWORDS="amd64 ~amd64"

RDEPEND=">=virtual/jre-1.8"
DEPEND="${DEPEND}
    >=virtual/jdk-1.8
    dev-java/gradle-bin"

src_prepare()
{
    # Make sure the proper version string gets built onto the binaries
    sed -i \
        -e 's/^versionBase=.*$/versionBase='${PVR}'/' \
        -e 's/^version=.*$/version='${PVR}'/'         \
        gradle.properties
}

src_compile()
{
    GRADLE_USER_HOME="${WORKDIR}/.gradle" ./make vasaDeploy
}

src_install()
{
    doins ${S}/build/libs/*.jar

    # Set our version number into the systemd unit file before we install it.
    mkdir -p "${DP}/systemd"
    sed -e 's|__JAVA__|'${JAVA}'|g' \
        -e 's|__PV__|'${PV}'|g'		\
        -e 's|__PVR__|'${PVR}'|g'	\
        -e 's|__SFVASA_HOME__|'${PREFIX}'|g' \
        "${FILESDIR}/sfvasa.service" > "${DP}/systemd/sfvasa.service" || die "Error installing sfvasa.service"
}
