# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils systemd user

MY_PN=${PN/-bin}
MY_PV=${PV%.*}.v${PV##*.}

DESCRIPTION="Jetty is an full-featured web and applicaction server implemented entirely in Java."
HOMEPAGE="http://www.mortbay.org/jetty-6/"
SRC_URI="http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${MY_PV}/jetty-distribution-${MY_PV}.zip"
SLOT="0"

LICENSE="Apache-2.0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	dev-java/java-config"
RDEPEND=">=virtual/jdk-1.5"

JETTY_HOME="/opt/${MY_PN}"

S="${WORKDIR}/jetty-distribution-${MY_PV}"

pkg_setup() {
	enewgroup jetty
	enewuser jetty -1 /bin/bash "${JETTY_HOME}" jetty
}

src_prepare() {
	# Set JETTY_HOME and JETTY_RUN directly in bin/jetty.sh so we don't have to deal with problematic env.d files. And
	# setting them in systemd service file only is insuffucient since we want it to work through lower level native
	# 'jetty' binary.
	sed -i $'\|#!/usr/bin/env bash|a JETTY_HOME="/opt/jetty"\\nJETTY_RUN="/var/run/jetty"' bin/jetty.sh || die
}

src_install() {
	# Setup systemd
	systemd_newunit "${FILESDIR}/${MY_PN}.service" "${MY_PN}.service"

	# Install required files into JETTY_HOME
	dodir "${JETTY_HOME}"
	insinto "${JETTY_HOME}"
	doins start.jar
	newbin bin/jetty.sh jetty
	doins -r etc
	doins -r lib
	doins -r resources
	doins -r modules
	doins start.ini
	dodir "${JETTY_HOME}/webapps"
	dodir "${JETTY_HOME}/etc/contexts"
	dosym "${JETTY_HOME}/etc" "/etc/${MY_PN}"

	# Fix permissions and ownership
	fowners -R jetty:jetty "${JETTY_HOME}"
}
