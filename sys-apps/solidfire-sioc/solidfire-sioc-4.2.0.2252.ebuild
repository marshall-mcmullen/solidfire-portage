# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2


EAPI=5

inherit solidfire

DESCRIPTION="NetApp SolidFire Storage I/O Control"
HOMEPAGE="https://www.solidfire.com"

if [[ "${PV}" =~ "_pre" ]]; then
    MY_PV="${PV%_pre*}"
    BUILD="${PV##*_pre}"
    SRC_URI="https://bitbucket.org/solidfire/vcenter-plugin/get/develop/${MY_PV}.${BUILD}.tar.bz2 -> solidfire-vcenter-plugin-${PV}.tar.bz2"
else
    MY_PV="${PV%.*}"
    BUILD="${PV##*.}"
    SRC_URI="https://bitbucket.org/solidfire/vcenter-plugin/get/release/${PV}.tar.bz2 -> solidfire-vcenter-plugin-${PV}.tar.bz2"
fi

LICENSE="NetApp"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.7
    dev-java/java-config
    dev-java/maven-bin:*
    www-servers/jetty-bin"
RDEPEND=">=virtual/jre-1.7"

# Jetty will not start if /opt/jetty/start.ini and /opt/jetty/etc/keystore and /opt/jetty/etc/jetty-ssl.xml are symlinks
# so unfortunately we need to make these not symlinks using eselect like we normally do. We also need to allow Jetty to
# restart the sioc service, which requires creating a file in /etc/sudoers.d

SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=(
    "/opt/jetty/start.ini"
    "/opt/jetty/etc/jetty-ssl.xml"
    "/opt/jetty/etc/keystore"
    "/opt/jetty/webapps/solidfire-mnode.war"
    "/opt/jetty/webapps/root/index.css"
    "/opt/jetty/webapps/root/solidfire-plugin-4.2.0-bin.zip"
    "/opt/jetty/webapps/root/NetApp_logo_vrt_white-on-alpha_rgb_lrg.png"
    "/opt/jetty/webapps/root/favicon.ico"
    "/opt/jetty/webapps/root/index.html"
    "/etc/sudoers.d/jetty"
)

src_prepare()
{
    set -e

    # Paths in Ember are different than in Ubuntu
    # sioc package path on Ember is '/sf/packages/sioc' not '/opt/solidfire/sioc'
    einfo "Fixing sioc paths"
    grep -Rl '/opt/solidfire/' . | while read fname; do
        echo "${fname}"
        sed -i 's|/opt/solidfire|/sf/packages|g' "${fname}"
    done

    # Logging path on Ember is '/var/log' not '/var/log/solidfire'
    einfo "Fixing logging paths"
    for fname in $(grep -Rl '/var/log/solidfire/' .); do
        echo "${fname}"
        sed -i 's|/var/log/solidfire|/var/log|g' "${fname}"
    done

    # pom.xml file auto increments the buildnumber inside buildNumber.properties on every compile.
    # Unfortunately, there's no way to disable the plugin through maven directly. Moreover, even if we change the phase
    # of the plugin from 'validate' to 'none' like we did in earlier builds, that breaks VCP registration. There are
    # side-effects of the buildnumber-maven-plugin running that we do not want to bypass. Instead of trying to chase 
    # all those down, we just manually set the current build number to be one less than the expected value knowing that
    # the plugin is going to increment it by 1 to the desired value. In src_compile we validate that the right build
    # number shows up in this file and in all the artifacts. We also validate this in our L1 and L2 tests.
    einfo "Decrementing buildNumber since buildnumber-maven-plugin auto increments it."
    local prior_build=$(( BUILD - 1 ))
    echo "buildNumber=${prior_build}" > buildNumber.properties.prior
    diff buildNumber.properties buildNumber.properties.prior || true
    mv buildNumber.properties.prior buildNumber.properties
}

src_compile()
{
    set -e
    mvn clean install -Dmaven.test.skip=true -Pcodesigning -X -Dangular.build=prod

    # Ensure that the buildNumber.properties file has what we expect in it even after doing the compile and install.
    einfo "Verifying buildNumber.properties"
    grep "buildNumber=${BUILD}" buildNumber.properties || die "buildNumber.properties has unexpected value: $(cat buildNumber.properties)"

    # Ensure no remnants of incorrect version number
    local prior_build=$(( BUILD - 1 ))
    local next_build=$(( BUILD + 1 ))
    for build in "${prior_build}" "${next_build}"; do
        if grep -aR "${MY_PV}.${build}" .; then
            die "Found unexpected version number ${MY_PV}.${build}"
        fi
        
        if find . | grep "${MY_PV}.${build}"; then
            die "Found unexpected version number ${MY_PV}.${build}"
        fi
    done

    return 0
}

src_install()
{
    set -e
    mkdir -p ${DP} ${DP}/systemd

    einfo "Installing SIOC files"
    cp --verbose keystore.jks ${DP}
    cp --verbose SolidFire-SIOC/target/solidfire-sioc-${MY_PV}*-boot.jar ${DP}/solidfire-sioc-boot.jar
    cp --verbose ${FILESDIR}/sioc.service ${DP}/systemd

    einfo "Install new VCP Registration files"
    mkdir -p ${DP}/jetty/{etc,webapps,webapps/root}
    cp --verbose SolidFire-Debian/src/main/resources/vcp-reg.bash ${DP}
    cp --verbose SolidFire-Debian/src/main/resources/{index.html,index.css,NetApp_logo*.png,favicon.ico} ${DP}/jetty/webapps/root
    for suffix in -bin.zip .xml; do
        fname=SolidFire-Plugin/target/solidfire-plugin-${MY_PV}*${suffix}
        cp --verbose ${fname} ${DP}/jetty/webapps/root
        md5sum ${DP}/jetty/webapps/root/$(basename ${fname}) > ${DP}/jetty/webapps/root/$(basename ${fname}).md5
        
        # Adjust file path in MD5 to reflect final merged path not temporary install path
        merged_path="${PREFIX}/jetty/webapps/root/$(basename ${fname})"
        sed -i "s|\(^[^#]\+\s\+\)\S\+|\1${merged_path}|" ${DP}/jetty/webapps/root/$(basename ${fname}).md5
        cat ${DP}/jetty/webapps/root/$(basename ${fname}).md5
    done

    chmod 755 ${DP}/jetty/{webapps,webapps/root}
    chmod -R 644 ${DP}/jetty/webapps/root/*

    cp SolidFire-MNode-War/target/solidfire-mnode-${MY_PV}*.war ${DP}/jetty/webapps/solidfire-mnode.war
    chmod 444 ${DP}/jetty/webapps/solidfire-mnode.war

    cp SolidFire-Registration/target/solidfire-registration-${MY_PV}*-jar-with-dependencies.jar ${DP}/solidfire-registration-jar-with-dependencies.jar
    chmod 555 ${DP}/solidfire-registration-jar-with-dependencies.jar

    # Copy customized Jetty files
    # NOTE: Jetty and SIOC webapps will not start if things are symlinks. So we have to copy them directly into the
    #       root path via pkg_postinst instead of using eselect.
    cp --verbose SolidFire-Debian/src/main/resources/{jetty-ssl.xml,keystore} ${DP}/jetty/etc
    cp --verbose SolidFire-Debian/src/main/resources/start.ini                ${DP}/jetty

    # Set up the proper keystore value
    keytool -importkeystore -srckeystore ${DP}/jetty/etc/keystore -destkeystore ${DP}/jetty/etc/keystore -deststoretype pkcs12 -srcstorepass solidfire -deststorepass solidfire
    rm --verbose --force ${DP}/jetty/etc/keystore.old

    # Add to the jetty suoders file so the jetty user to be able to restart the sioc service
    mkdir -p ${D}/etc/sudoers.d
    echo "%jetty ALL= NOPASSWD: /bin/systemctl restart sioc" > ${D}/etc/sudoers.d/jetty
    echo "%jetty ALL= NOPASSWD: /usr/bin/service sioc restart" >> ${D}/etc/sudoers.d/jetty
}

pkg_preinst()
{
    einfo "Removing non-sf jetty files"
    rm --verbose --force /opt/jetty/start.ini /opt/jetty/etc/{jetty-ssl.xml,keystore}

    einfo "Installing solidfire jetty files"
    cp --verbose ${DP}/jetty/start.ini /opt/jetty     || die
    cp --verbose ${DP}/jetty/etc/*     /opt/jetty/etc || die
    cp --recursive --verbose ${DP}/jetty/webapps/* /opt/jetty/webapps || die

    einfo "Creating /opt/jetty/logs"
    mkdir -p "/opt/jetty/logs"

    einfo "Updating permission"
    chown --recursive --verbose jetty:jetty "/opt/jetty"
    
    einfo "Removing login permissions for the jetty user"
    usermod -s /sbin/nologin jetty

    solidfire_pkg_preinst
}
