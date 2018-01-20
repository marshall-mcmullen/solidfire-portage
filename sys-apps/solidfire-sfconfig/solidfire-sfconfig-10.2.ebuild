# Copyright 2018 NetApp. Inc. All rights reserved.

EAPI="5"
inherit mercurial solidfire

DESCRIPTION="SolidFire node configuration daemon"
HOMEPAGE="https://www.solidfire.com"

# Commit message for this version:
# Update neon-patch3 version number to 10.3.0.28.
EHG_REPO_URI="http://hgserve.eng.solidfire.net/hg/neon-patch3"
EHG_REVISION="1b95431f4701"

LICENSE="SolidFire"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	>=app-misc/jq-1.4
	=app-arch/snappy-solidfire-1.0.4
	=app-text/xml2json-solidfire-1.0-r2
	=app-crypt/libgfshare-solidfire-1.0.5
	=app-emulation/solidfire-vasa-2.9.2
	=dev-cpp/google-libs-solidfire-2.0-r2
	=dev-cpp/jemalloc-debug-solidfire-3.6.0
	=dev-cpp/jemalloc-solidfire-3.6.0
	=dev-cpp/tbb-solidfire-4.3.20141204-r1
	=dev-java/icedtea-bin-3.3.0
	=dev-libs/boost-solidfire-1.57.0-r3
	=dev-libs/crypto++-solidfire-5.6.2-r2
	=dev-libs/jsoncpp-solidfire-0.6.0-r8
	=dev-libs/liblzf-solidfire-3.6-r6
	=dev-libs/skein-solidfire-121508-r6
	=dev-libs/snapmirror-solidfire-1.0.4564101
	=net-analyzer/net-snmp-5.7.3-r5
	=net-dns/c-ares-1.12.0
	=net-libs/libmicrohttpd-solidfire-0.9.32-r4
	=net-misc/curl-solidfire-7.39.0-r1
	net-misc/ntp
	=net-nds/openldap-2.4.44
	sys-apps/dmidecode
	sys-apps/hdparm
	sys-apps/iproute2
	sys-apps/lshw
	=sys-apps/nmsdk-solidfire-5.7
	=sys-cluster/zookeeper-solidfire-3.5.0-r34
	sys-devel/gdb
	=sys-libs/libunwind-solidfire-1.1.1-r1
	=www-servers/pion-solidfire-5.0.0-r13
	dev-libs/crypto++
"

RDEPEND="${DEPEND}"

src_compile()
{
	emake CONF=Release sfconfig
}

src_install()
{
	mkdir -p ${DP}/bin
	cp -p ${S}/build/Release/bin/sfconfig ${DP}/bin
	dopathlinks /sf/bin ${DP}/bin/sfconfig

	mkdir -p ${DP}/etc/systemd/system
	cp -p ${S}/install/storage/etc/systemd/system/sfconfig.service ${DP}/etc/systemd/system
	dopathlinks /etc/systemd/system ${DP}/etc/systemd/system/sfconfig.service

	mkdir -p ${DP}/webmgmt/${PV}
	cp -rp ${S}/webmgmt/* ${DP}/webmgmt/${PV}
	dopathlinks /sf/etc/webmgmt ${DP}/webmgmt/${PV}
}
