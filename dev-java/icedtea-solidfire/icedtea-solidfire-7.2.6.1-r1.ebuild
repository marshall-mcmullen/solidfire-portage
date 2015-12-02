# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# Build written by Andrew John Hughes (gnu_andrew@member.fsf.org)

EAPI="5"
inherit check-reqs java-pkg-2 java-vm-2 multiprocessing versionator solidfire-libs virtualx

ICEDTEA_VER=$(get_version_component_range 2-4)
ICEDTEA_BRANCH=$(get_version_component_range 2-3)
ICEDTEA_PKG=icedtea-${ICEDTEA_VER}
ICEDTEA_PRE=$(get_version_component_range _)
CORBA_TARBALL="2545636482d6.tar.bz2"
JAXP_TARBALL="ffbe529eeac7.tar.bz2"
JAXWS_TARBALL="b9776fab65b8.tar.bz2"
JDK_TARBALL="61d3e001dee6.tar.bz2"
LANGTOOLS_TARBALL="9c6e1de67d7d.tar.bz2"
OPENJDK_TARBALL="39b2c4354d0a.tar.bz2"
HOTSPOT_TARBALL="b19bc5aeaa09.tar.bz2"

CORBA_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-corba-${CORBA_TARBALL}"
JAXP_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jaxp-${JAXP_TARBALL}"
JAXWS_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jaxws-${JAXWS_TARBALL}"
JDK_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jdk-${JDK_TARBALL}"
LANGTOOLS_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-langtools-${LANGTOOLS_TARBALL}"
OPENJDK_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-openjdk-${OPENJDK_TARBALL}"
HOTSPOT_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-hotspot-${HOTSPOT_TARBALL}"

CACAO_GENTOO_TARBALL="icedtea-${CACAO_TARBALL}"
JAMVM_GENTOO_TARBALL="icedtea-${JAMVM_TARBALL}"

DROP_URL="http://icedtea.classpath.org/download/drops"
ICEDTEA_URL="${DROP_URL}/icedtea${SLOT}/${ICEDTEA_VER}"

DESCRIPTION="A harness to build OpenJDK using Free Software build tools and dependencies"
HOMEPAGE="http://icedtea.classpath.org"
SRC_PKG="${ICEDTEA_PKG}.tar.xz"
SRC_URI="
	http://icedtea.classpath.org/download/source/${SRC_PKG}
	${ICEDTEA_URL}/openjdk.tar.bz2 -> ${OPENJDK_GENTOO_TARBALL}
	${ICEDTEA_URL}/corba.tar.bz2 -> ${CORBA_GENTOO_TARBALL}
	${ICEDTEA_URL}/jaxp.tar.bz2 -> ${JAXP_GENTOO_TARBALL}
	${ICEDTEA_URL}/jaxws.tar.bz2 -> ${JAXWS_GENTOO_TARBALL}
	${ICEDTEA_URL}/jdk.tar.bz2 -> ${JDK_GENTOO_TARBALL}
	${ICEDTEA_URL}/hotspot.tar.bz2 -> ${HOTSPOT_GENTOO_TARBALL}
	${ICEDTEA_URL}/langtools.tar.bz2 -> ${LANGTOOLS_GENTOO_TARBALL}"

LICENSE="Apache-1.1 Apache-2.0 GPL-1 GPL-2 GPL-2-with-linking-exception LGPL-2 MPL-1.0 MPL-1.1 public-domain W3C"
KEYWORDS="~amd64 amd64 ~arm ~x86"
RESTRICT="test"

RDEPEND="
	>=dev-util/systemtap-1
	>=media-libs/giflib-4.1.6:=
	>=media-libs/lcms-2.5
	>=sys-libs/zlib-1.2.3:=
	virtual/jpeg:0="

# Only ant-core-1.8.1 has fixed ant -diagnostics when xerces+xalan are not present.
# ca-certificates, perl and openssl are used for the cacerts keystore generation
DEPEND="${RDEPEND}
	|| (
		>=dev-java/gcj-jdk-4.3
		dev-java/icedtea-bin:7
		dev-java/icedtea-bin:6
		dev-java/icedtea:7
		dev-java/icedtea:6
	)
	app-arch/cpio
	app-arch/unzip
	app-arch/zip
	app-misc/ca-certificates
	>=dev-java/ant-core-1.8.2
	dev-lang/perl
	>=dev-libs/libxslt-1.1.26
	dev-libs/openssl
	sys-apps/attr
	sys-apps/lsb-release
	=sys-devel/gcc-solidfire-4.8.1
	virtual/pkgconfig"

S="${WORKDIR}"/${ICEDTEA_PKG}

icedtea_check_requirements() {
	local CHECKREQS_DISK_BUILD="8500M"

	check-reqs_pkg_${EBUILD_PHASE}
}

pkg_pretend() {
	icedtea_check_requirements
}

pkg_setup() {
	icedtea_check_requirements

	JAVA_PKG_WANT_BUILD_VM="
		icedtea-7 icedtea-bin-7
		icedtea-6 icedtea-bin-6
		gcj-jdk"
	JAVA_PKG_WANT_SOURCE="1.5"
	JAVA_PKG_WANT_TARGET="1.5"

	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${SRC_PKG}
}

java_prepare() {
	
	# CUPS is always needed at build time but you can at least make it dlopen.
	sed -i 's/SYSTEM_CUPS="true"/SYSTEM_CUPS="false"/g' Makefile.in || die

	# For bootstrap builds as the sandbox control file might not yet exist.
	addpredict /proc/self/coredump_filter

	# icedtea doesn't like some locales. #330433 #389717
	export LANG="C" LC_ALL="C"
}

src_configure() {
	local vm=$(java-pkg_get-current-vm)

	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS

	econf \
		--enable-bootstrap \
		--with-parallel-jobs=$(makeopts_jobs) \
		--with-openjdk-src-zip="${DISTDIR}/${OPENJDK_GENTOO_TARBALL}" \
		--with-corba-src-zip="${DISTDIR}/${CORBA_GENTOO_TARBALL}" \
		--with-jaxp-src-zip="${DISTDIR}/${JAXP_GENTOO_TARBALL}" \
		--with-jaxws-src-zip="${DISTDIR}/${JAXWS_GENTOO_TARBALL}" \
		--with-jdk-src-zip="${DISTDIR}/${JDK_GENTOO_TARBALL}" \
		--with-hotspot-src-zip="${DISTDIR}/${HOTSPOT_GENTOO_TARBALL}" \
		--with-langtools-src-zip="${DISTDIR}/${LANGTOOLS_GENTOO_TARBALL}" \
		--with-jdk-home="$(java-config -O)" \
		--disable-downloading --disable-Werror \
		--disable-hotspot-tests --disable-jdk-tests \
		--enable-system-lcms \
		--enable-system-jpeg \
		--enable-system-zlib \
		--disable-system-gif \
		--disable-system-png \
		--enable-optimizations \
		--disable-docs \
		--disable-system-gtk \
		--disable-infinality \
		--disable-system-kerberos \
		--without-pax \
		--disable-nss \
		--without-rhino \
		--disable-system-sctp \
		--disable-system-pcsc \
		--disable-sunec
}

src_compile() {
	# Would use GENTOO_VM otherwise.
	export ANT_RESPECT_JAVA_HOME=TRUE

	# With ant >=1.8.2 all required tasks are part of ant-core
	export ANT_TASKS="none"

	emake
}

src_test() {
	# Use Xvfb for tests
	unset DISPLAY

	Xemake check
}

src_install() {
	default

	# Remove things we don't need:
	# (1) ALSA
	# (2) AWT
	# (3) Examples
	# (4) source code
	rm -vr ${DP}/jre/lib/$(get_system_arch)/libjsoundalsa.*                       \
	       ${DP}/jre/lib/$(get_system_arch)/{xawt,libsplashscreen.*,libjavagtk.*} \
		   ${DP}/{,jre/}bin/policytool ${DP}/bin/appletviewer                     \
		   ${DP}/demo ${DP}/sample                                                \
		   ${DP}/src.zip                                                          \
		|| die

	# Fix the permissions.
	find "${DP}" \! -type l \( -perm /111 -exec chmod 755 {} \; -o -exec chmod 644 {} \; \) || die

	# Version binaries
	einfo "Versioning binaries"
	local bin
	for bin in $(find ${DP}/bin); do
		echo "${bin} -> ${bin}${PS}"
		mv ${bin} ${bin}${PS}
	done
}

# Override the functions provided by java-vm-2 as we don't actually want this version 
# of java fully integrated into the OS since it's very purpose-built.
for func in pkg_setup pkg_postinst pkg_prerm pkg_postrm; do
	eval "${func}() { :; }"
done
