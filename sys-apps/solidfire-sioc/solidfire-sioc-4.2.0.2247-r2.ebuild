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
# so unfortunately we need to make these not symlinks using eselect like we normally do.
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
)

src_prepare()
{
	set -e

	# Paths in Ember are different than in Ubuntu
	einfo "Fixing sioc path in vcp-reg.bash"
	sed -i 's|/opt/solidfire|/sf/packages/sioc|g' SolidFire-Debian/src/main/resources/vcp-reg.bash 

	# Logging path on Ember is '/var/log' not '/var/log/solidfire'
	einfo "Fixing logging paths"
	for fname in $(grep -Rl '/var/log/solidfire/' .); do
		echo "${fname}"
		sed -i 's|/var/log/solidfire|/var/log|g' "${fname}"
	done
}

src_compile()
{
	set -e
	mvn clean install -Dmaven.test.skip=true
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
	cp --verbose SolidFire-Plugin/target/solidfire-plugin-${MY_PV}*-bin.zip ${DP}/jetty/webapps/root
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
}

pkg_preinst()
{
	einfo "Removing non-solidfire jetty files"
	rm --verbose --force /opt/jetty/start.ini /opt/jetty/etc/{jetty-ssl.xml,keystore}

	einfo "Installing solidfire jetty files"
	cp --verbose ${DP}/jetty/start.ini /opt/jetty     || die
	cp --verbose ${DP}/jetty/etc/*     /opt/jetty/etc || die
	cp --recursive --verbose ${DP}/jetty/webapps/* /opt/jetty/webapps || die

	einfo "Creating /opt/jetty/logs"
	mkdir -p "/opt/jetty/logs"

	einfo "Updating permission"
	chown --recursive --verbose jetty:jetty "/opt/jetty"
	
	solidfire_pkg_preinst
}
