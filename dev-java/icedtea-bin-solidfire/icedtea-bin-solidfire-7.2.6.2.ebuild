# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-vm-2 multilib prefix toolchain-funcs versionator solidfire-libs

TARBALL_VERSION="${PV}"

DESCRIPTION="A Gentoo-made binary build of the IcedTea JDK"
HOMEPAGE="http://icedtea.classpath.org"
SRC_URI="https://dev.gentoo.org/~chewi/distfiles/${MY_PN}-core-${TARBALL_VERSION}-amd64.tar.xz"

LICENSE="GPL-2-with-linking-exception"
KEYWORDS="amd64"

RESTRICT="preserve-libs strip"
QA_PREBUILT="opt/.*"

# gsettings-desktop-schemas is needed for native proxy support. #431972
RDEPEND=">=dev-libs/glib-2.42:2
	>=dev-libs/nss-3.16.1-r1
	>=dev-libs/nspr-4.10
	>=gnome-base/gsettings-desktop-schemas-3.12.2
	media-fonts/dejavu
	>=media-libs/fontconfig-2.11:1.0
	>=media-libs/freetype-2.5.5:2
	>=media-libs/lcms-2.6:2
	>=sys-devel/gcc-4.9.3
	>=sys-libs/glibc-2.21
	>=sys-libs/zlib-1.2.8-r1
	virtual/jpeg:62"

DEPEND="dev-util/patchelf"

PDEPEND=""

pkg_pretend() {
	if [[ "$(tc-is-softfloat)" != "no" ]]; then
		die "These binaries require a hardfloat system."
	fi
}

src_prepare() {
	
	# Remove stuff we don't want
	rm -vr	jre/lib/$(get_system_arch)/libjsoundalsa.*			\
			jre/lib/$(get_system_arch)/{xawt,libsplashscreen.*}	\
			{,jre/}bin/policytool bin/appletviewer				\
			{,jre/}bin/javaws									\
			{,jre/}bin/itweb-settings                           \
			jre/lib/$(get_system_arch)/libjavagtk.*				\
		|| die

	# NSS is already required because of SunEC. The nss flag in the
	# icedtea package just comments or uncomments this line.
	sed -i "/=sun\.security\.pkcs11\.SunPKCS11/s/^#*/#)/" jre/lib/security/java.security || die

	# Fix the RPATHs
	local old="/usr/$(get_libdir)/icedtea7"
	local new="${PREFIX}"
	local elf rpath

	for elf in $(find -type f -executable ! -name "*.cgi" || die); do
		rpath=$(patchelf --print-rpath "${elf}" || die "patchelf ${elf}")

		if [[ -n "${rpath}" ]]; then
			patchelf --set-rpath "${rpath//${old}/${new}}" "${elf}" || die "patchelf ${elf}"
		fi
	done
}

src_install() {

	dodir "${PREFIX}"

	# doins doesn't preserve executable bits.
	cp -pRP bin include jre lib man "${DP}" || die

	# Both icedtea itself and the icedtea ebuild set PAX markings but we
	# disable them for the icedtea-bin build because the line below will
	# respect end-user settings when icedtea-bin is actually installed.
	java-vm_set-pax-markings "${DP}"

	# Version binaries
	einfo "Versioning binaries"
	local bin
	for bin in $(find ${DP}/bin ${DP}/jre/bin -type f); do
		echo "   ${bin} -> ${bin}${PS}"
		mv ${bin} ${bin}${PS} || die "mv ${bin} ${bin}${PS}"
	done
}

# Override the functions provided by java-vm-2 as we don't actually want this version 
# of java fully integrated into the OS since it's very purpose-built.
for func in pkg_setup pkg_postinst pkg_prerm pkg_postrm; do
	eval "${func}() { :; }"
done
