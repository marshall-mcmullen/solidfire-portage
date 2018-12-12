# Copyright 2017-2018 NetApp, Inc. All rights reserved.

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
    dev-vcs/mercurial
    dev-java/gradle-bin"

PATCHES=(
    "${FILESDIR}/commit_string.patch"
)

src_prepare()
{
    base_src_prepare

    # Make sure the proper version string gets built onto the binaries
    sed -i \
        -e 's/^versionBase=.*$/versionBase='${PV}'/' \
        -e 's/^version=.*$/version='${PV}'/'         \
        gradle.properties
}

src_compile()
{
    GRADLE_USER_HOME="${WORKDIR}/.gradle" ./make vasaDeploy
}

src_install()
{
    doins ${S}/build/libs/*.jar
    
	# Create version specific sfvasa.service"
    einfo "Creating sfvasa.service"
	mkdir -p "${DP}/systemd"
	cat <<- EOF > "${DP}/systemd/sfvasa.service"
	[Unit]
	Description=SolidFire Vasa Provider
	ConditionPathExists=${PREFIX}/sf_cluster.conf

	[Service]
	Type=simple
	User=root
	WorkingDirectory=/sf
	Restart=always
	ExecStart=${JAVA} \
            -javaagent:${PREFIX}/solidfire-vasa-${PV}-all-${PV}.jar \
            -jar ${PREFIX}/solidfire-vasa-${PV}-all-${PV}.jar \
            --context-path vasa/services/vasaService \
            --vasa-home ${PREFIX}

	[Install]
	WantedBy=multi-user.target
	EOF
}
