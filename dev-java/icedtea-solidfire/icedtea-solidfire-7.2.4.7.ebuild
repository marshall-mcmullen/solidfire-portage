# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/icedtea/icedtea-7.2.4.7.ebuild,v 1.2 2014/05/17 15:22:54 swift Exp $
# Build written by Andrew John Hughes (gnu_andrew@member.fsf.org)

# *********************************************************
# * IF YOU CHANGE THIS EBUILD, CHANGE ICEDTEA-6.* AS WELL *
# *********************************************************

EAPI="5"
VTAG="solidfire"
inherit gcc-${VTAG}-4.8.1 java-pkg-2 java-vm-2 pax-utils prefix versionator versionize virtualx

ICEDTEA_VER=$(get_version_component_range 2-)
ICEDTEA_BRANCH=$(get_version_component_range 2-3)
ICEDTEA_PKG=icedtea-${ICEDTEA_VER}
CORBA_TARBALL="e6ad5b912691.tar.gz"
JAXP_TARBALL="94b7e8e0d96f.tar.gz"
JAXWS_TARBALL="bd9a50a78d04.tar.gz"
JDK_TARBALL="9448fff93286.tar.gz"
LANGTOOLS_TARBALL="8c26a3c39128.tar.gz"
OPENJDK_TARBALL="13970e76b784.tar.gz"
HOTSPOT_TARBALL="69b542696e5b.tar.gz"
CACAO_TARBALL="e215e36be9fc.tar.gz"
JAMVM_TARBALL="jamvm-ac22c9948434e528ece451642b4ebde40953ee7e.tar.gz"

CORBA_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-corba-${CORBA_TARBALL}"
JAXP_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jaxp-${JAXP_TARBALL}"
JAXWS_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jaxws-${JAXWS_TARBALL}"
JDK_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jdk-${JDK_TARBALL}"
LANGTOOLS_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-langtools-${LANGTOOLS_TARBALL}"
OPENJDK_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-openjdk-${OPENJDK_TARBALL}"
HOTSPOT_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-hotspot-${HOTSPOT_TARBALL}"
CACAO_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-cacao-${CACAO_TARBALL}"
JAMVM_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-${JAMVM_TARBALL}"

DESCRIPTION="A harness to build OpenJDK using Free Software build tools and dependencies"
HOMEPAGE="http://icedtea.classpath.org"
SRC_PKG="${ICEDTEA_PKG}.tar.xz"
SRC_URI="
	http://icedtea.classpath.org/download/source/${SRC_PKG}
	http://icedtea.classpath.org/hg/release/icedtea7-forest-${ICEDTEA_BRANCH}/archive/${OPENJDK_TARBALL}
	 -> ${OPENJDK_GENTOO_TARBALL}
	http://icedtea.classpath.org/hg/release/icedtea7-forest-${ICEDTEA_BRANCH}/corba/archive/${CORBA_TARBALL}
	 -> ${CORBA_GENTOO_TARBALL}
	http://icedtea.classpath.org/hg/release/icedtea7-forest-${ICEDTEA_BRANCH}/jaxp/archive/${JAXP_TARBALL}
	 -> ${JAXP_GENTOO_TARBALL}
	http://icedtea.classpath.org/hg/release/icedtea7-forest-${ICEDTEA_BRANCH}/jaxws/archive/${JAXWS_TARBALL}
	 -> ${JAXWS_GENTOO_TARBALL}
	http://icedtea.classpath.org/hg/release/icedtea7-forest-${ICEDTEA_BRANCH}/jdk/archive/${JDK_TARBALL}
	 -> ${JDK_GENTOO_TARBALL}
	http://icedtea.classpath.org/hg/release/icedtea7-forest-${ICEDTEA_BRANCH}/hotspot/archive/${HOTSPOT_TARBALL}
	 -> ${HOTSPOT_GENTOO_TARBALL}
	http://icedtea.classpath.org/hg/release/icedtea7-forest-${ICEDTEA_BRANCH}/langtools/archive/${LANGTOOLS_TARBALL}
	 -> ${LANGTOOLS_GENTOO_TARBALL}
	http://icedtea.classpath.org/download/drops/cacao/${CACAO_TARBALL} -> ${CACAO_GENTOO_TARBALL}
	http://icedtea.classpath.org/download/drops/jamvm/${JAMVM_TARBALL} -> ${JAMVM_GENTOO_TARBALL}"

LICENSE="Apache-1.1 Apache-2.0 GPL-1 GPL-2 GPL-2-with-linking-exception LGPL-2 MPL-1.0 MPL-1.1 public-domain W3C"
KEYWORDS="~amd64 amd64"

IUSE="+jbootstrap test"

# Dependencies #
RDEPEND="
	>=media-libs/giflib-4.1.6:=
	>=media-libs/lcms-2.5
	>=media-libs/libpng-1.2:=
	>=sys-libs/zlib-1.2.3:=
	virtual/jpeg:0="

# Only ant-core-1.8.1 has fixed ant -diagnostics when xerces+xalan are not present.
# ca-certificates, perl and openssl are used for the cacerts keystore generation
# xext headers have two variants depending on version - bug #288855
# autoconf - as long as we use eautoreconf, version restrictions for bug #294918
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
	dev-java/ant-core
	dev-lang/perl
	>=dev-libs/libxslt-1.1.26
	dev-libs/openssl
	virtual/pkgconfig
	sys-apps/attr
	sys-apps/lsb-release"

S="${WORKDIR}"/${ICEDTEA_PKG}

pkg_setup() {
	JAVA_PKG_WANT_BUILD_VM="
		icedtea-7 icedtea-bin-7 icedtea7
		icedtea-6 icedtea-bin-6 icedtea6 icedtea6-bin
		gcj-jdk"
	JAVA_PKG_WANT_SOURCE="1.5"
	JAVA_PKG_WANT_TARGET="1.5"

	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${SRC_PKG}
}

java_prepare() {
	# For bootstrap builds as the sandbox control file might not yet exist.
	addpredict /proc/self/coredump_filter

	# icedtea doesn't like some locales. #330433 #389717
	export LANG="C" LC_ALL="C"
}

src_configure() {
	local config bootstrap use_zero zero_config
	local vm=$(java-pkg_get-current-vm)

	# Whether to bootstrap
	bootstrap="disable"
	if use jbootstrap; then
		bootstrap="enable"
	fi

	if has "${vm}" gcj-jdk; then
		# gcj-jdk ensures ecj is present.
		use jbootstrap || einfo "bootstrap is necessary when building with ${vm}, ignoring USE=\"-jbootstrap\""
		bootstrap="enable"
		local ecj_jar="$(readlink "${EPREFIX}"/usr/share/eclipse-ecj/ecj.jar)"
		config="${config} --with-ecj-jar=${ecj_jar}"
	fi

	config="${config} --${bootstrap}-bootstrap"

	# OpenJDK-specific parallelism support. Bug #389791, #337827
	# Implementation modified from waf-utils.eclass
	# Note that "-j" is converted to "-j1" as the system doesn't support --load-average
	local procs=$(echo -j1 ${MAKEOPTS} | sed -r "s/.*(-j\s*|--jobs=)([0-9]+).*/\2/" )
	config="${config} --with-parallel-jobs=${procs}";
	einfo "Configuring using --with-parallel-jobs=${procs}"

	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS

	econf ${config} \
		--with-openjdk-src-zip="${DISTDIR}/${OPENJDK_GENTOO_TARBALL}" \
		--with-corba-src-zip="${DISTDIR}/${CORBA_GENTOO_TARBALL}" \
		--with-jaxp-src-zip="${DISTDIR}/${JAXP_GENTOO_TARBALL}" \
		--with-jaxws-src-zip="${DISTDIR}/${JAXWS_GENTOO_TARBALL}" \
		--with-jdk-src-zip="${DISTDIR}/${JDK_GENTOO_TARBALL}" \
		--with-hotspot-src-zip="${DISTDIR}/${HOTSPOT_GENTOO_TARBALL}" \
		--with-langtools-src-zip="${DISTDIR}/${LANGTOOLS_GENTOO_TARBALL}" \
		--with-cacao-src-zip="${DISTDIR}/${CACAO_GENTOO_TARBALL}" \
		--with-jamvm-src-zip="${DISTDIR}/${JAMVM_GENTOO_TARBALL}" \
		--with-jdk-home="$(java-config -O)" \
		--with-abs-install-dir="${EPREFIX}/usr/$(get_libdir)/icedtea${SLOT}" \
		--disable-downloading --disable-Werror \
		--enable-system-lcms \
		--enable-optimizations \
		--disable-docs \
		--disable-nss \
		--disable-pulse-java \
		--disable-jamvm \
		--disable-system-kerberos \
		--without-pax \
		--without-rhino
}

src_compile() {
	# Would use GENTOO_VM otherwise.
	export ANT_RESPECT_JAVA_HOME=TRUE

	# With ant >=1.8.2 all required tasks are part of ant-core
	export ANT_TASKS="none"

	emake
}

src_install() {
	local dest="/usr/$(get_libdir)/icedtea${SLOT}"
	local ddest="${ED}/${dest}"
	dodir "${dest}"

	dodoc README NEWS AUTHORS
	dosym /usr/share/doc/${PF} /usr/share/doc/${PN}${SLOT}

	cd openjdk.build/j2sdk-image || die

	# Ensures HeadlessGraphicsEnvironment is used.
	rm -r jre/lib/$(get_system_arch)/xawt || die

	# Don't hide classes
	rm lib/ct.sym || die

	#402507
	mkdir jre/.systemPrefs || die
	touch jre/.systemPrefs/.system.lock || die
	touch jre/.systemPrefs/.systemRootModFile || die

	# doins can't handle symlinks.
	cp -vRP bin include jre lib man "${ddest}" || die

	dodoc ASSEMBLY_EXCEPTION THIRD_PARTY_README

	# Fix the permissions.
	find "${ddest}" \! -type l \( -perm /111 -exec chmod 755 {} \; -o -exec chmod 644 {} \; \) || die

	# Needs to be done before generating cacerts
	java-vm_set-pax-markings "${ddest}"

	# We need to generate keystore - bug #273306
	einfo "Generating cacerts file from certificates in ${EPREFIX}/usr/share/ca-certificates/"
	mkdir "${T}/certgen" && cd "${T}/certgen" || die
	cp "${FILESDIR}/generate-cacerts.pl" . && chmod +x generate-cacerts.pl || die
	for c in "${EPREFIX}"/usr/share/ca-certificates/*/*.crt; do
		openssl x509 -text -in "${c}" >> all.crt || die
	done
	./generate-cacerts.pl "${ddest}/bin/keytool" all.crt || die
	cp -vRP cacerts "${ddest}/jre/lib/security/" || die
	chmod 644 "${ddest}/jre/lib/security/cacerts" || die

	# OpenJDK7 should be able to use fontconfig instead, but wont hurt to
	# install it anyway. Bug 390663
	cp "${FILESDIR}"/fontconfig.Gentoo.properties.src "${T}"/fontconfig.Gentoo.properties || die
	eprefixify "${T}"/fontconfig.Gentoo.properties
	insinto "${dest}"/jre/lib
	doins "${T}"/fontconfig.Gentoo.properties

	set_java_env "${FILESDIR}/icedtea.env"
	java-vm_revdep-mask "${dest}"
	java-vm_sandbox-predict /proc/self/coredump_filter
}

pkg_preinst() {
	if has_version "<=dev-java/icedtea-7.2.0:7"; then
		# portage would preserve the symlink otherwise, related to bug #384397
		rm -f "${EROOT}/usr/lib/jvm/icedtea7"
		elog "To unify the layout and simplify scripts, the identifier of Icedtea-7*"
		elog "has changed from 'icedtea7' to 'icedtea-7' starting from version 7.2.0-r1"
		elog "If you had icedtea7 as system VM, the change should be automatic, however"
		elog "build VM settings in /etc/java-config-2/build/jdk.conf are not changed"
		elog "and the same holds for any user VM settings. Sorry for the inconvenience."
	fi
}
