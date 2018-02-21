# Copyright 2018 NetApp, Inc. All rights reserved.

EAPI=5

# Setup variables to upstream source that doesn't have solidfire in it.
MY_P="${P//-solidfire}"
MY_PN="${PN//-solidfire}"
MY_PF="${PF//-solidfire}"

SRC_URI="
	https://dev.gentoo.org/~aidecoe/distfiles/${CATEGORY}/${MY_PN}/gentoo-logo.png"


MY_PV="$(sed 's/\.[[:digit:]]\+s//' <<< "${PV}")"

AUTOTOOLS_AUTORECONF="1"
SRC_URI="${SRC_URI} https://www.freedesktop.org/software/plymouth/releases/${MY_PN}-${MY_PV}.tar.bz2"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

inherit autotools-utils readme.gentoo systemd toolchain-funcs

DESCRIPTION="Graphical boot animation (splash) and logger"
HOMEPAGE="https://cgit.freedesktop.org/plymouth/"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 sparc x86"
IUSE="debug doc gdm +gtk +libkms +pango static-libs"

CDEPEND="
	>=media-libs/libpng-1.2.16:=
	doc? ( dev-libs/libxslt )
	gtk? (
		dev-libs/glib:2
		>=x11-libs/gtk+-3.14:3
		x11-libs/cairo )
	libkms? ( x11-libs/libdrm[libkms] )
	pango? ( >=x11-libs/pango-1.21 )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"
# Block due bug #383067
RDEPEND="${CDEPEND}
	virtual/udev
	!<sys-kernel/dracut-0.37-r3
"

DOC_CONTENTS="
	Follow the following instructions to set up Plymouth:\n
	https://dev.gentoo.org/~aidecoe/doc/en/plymouth.xml
"

PATCHES=(
	"${FILESDIR}/0.9.2-systemdsystemunitdir.patch"
	"${FILESDIR}/0.9.2-framebuffer-local-console.patch"
)

src_prepare() {
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-system-root-install=no
		--localstatedir=/var
		--without-rhgb-compat-link
		--enable-systemd-integration
		--with-boot-tty=/dev/tty7
		"$(systemd_with_unitdir)"
		$(use_enable debug tracing)
		$(use_enable doc documentation)
		$(use_enable gtk gtk)
		$(use_enable libkms drm)
		$(use_enable pango)
		$(use_enable gdm gdm-transition)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	insinto /usr/share/plymouth
	newins "${DISTDIR}"/gentoo-logo.png bizcom.png

	# Install compatibility symlinks as some rdeps hardcode the paths
	dosym /usr/bin/plymouth /bin/plymouth
	dosym /usr/sbin/plymouth-set-default-theme /sbin/plymouth-set-default-theme
	dosym /usr/sbin/plymouthd /sbin/plymouthd

	readme.gentoo_create_doc

	# looks like make install create /var/run/plymouth
	# this is not needed for systemd, same should hold for openrc
	# so remove
	rm -rf "${D}"/var/run
}

pkg_postinst() {
	readme.gentoo_print_elog
	if ! has_version "sys-kernel/dracut" && ! has_version "sys-kernel/genkernel-next[plymouth]"; then
		ewarn "If you want initramfs builder with plymouth support, please emerge"
		ewarn "sys-kernel/dracut or sys-kernel/genkernel-next[plymouth]."
	fi
}
