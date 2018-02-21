# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit java-pkg-2 solidfire

DESCRIPTION="SolidFire VASA (vSphere API for Storage Awareness) Provider"
HOMEPAGE="http://solidfire.com"
SRC_URI="http://bdr-jenkins.eng.solidfire.net/distfiles/${P}.tar.bz2"

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
    java -jar build/libs/sfvasa-${PVR}-all-${PVR}.jar --version 2>&1 | grep "Vasa Provider Version"
}

src_install()
{
    doins ${S}/build/libs/*.jar

    # Set our version number into the systemd unit file before we install it.
    mkdir -p "${DP}/systemd"
    sed \
        -e 's#__JAVA__#'${JAVA}'#g'          \
        -e 's#__SFVASA_VERSION__#'${PVR}'#g' \
        -e 's#__SFVASA_HOME__#'${PREFIX}'#g' \
        "${FILESDIR}/sfvasa.service" > "${DP}/systemd/sfvasa.service" || die "Error installing sfvasa.service"
}
