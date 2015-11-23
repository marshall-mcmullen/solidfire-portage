# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit gcc-solidfire-4.8.1 solidfire-libs

DESCRIPTION="SolidFire 3rd Party Libraries"
HOMEPAGE="http://www.solidfire.com"

SLOT="${PVR}"
KEYWORDS="~amd64 amd64"

RDEPEND="
	>=app-misc/jq-1.3
	=app-arch/snappy-solidfire-1.0.4
	=app-text/xml2json-solidfire-1.0
	=app-crypt/libgfshare-solidfire-1.0.5
	=dev-cpp/gflags-solidfire-2.0-r5
	=dev-cpp/glog-solidfire-0.3.3-r3
	=dev-cpp/gmock-solidfire-1.6.0-r4
	=dev-cpp/gtest-solidfire-1.6.0-r7
	=dev-cpp/jemalloc-debug-solidfire-3.6.0
	=dev-cpp/jemalloc-solidfire-3.6.0
	=dev-cpp/sparsehash-solidfire-2.0.2-r6
	=dev-cpp/tbb-solidfire-4.2-r2
	=dev-libs/boost-solidfire-1.54.0-r1
	=dev-libs/crypto++-solidfire-5.6.2-r1
	=dev-libs/jsoncpp-solidfire-0.6.0-r7
	=dev-libs/liblzf-solidfire-3.6-r6
	=dev-libs/skein-solidfire-121508-r5
	>=dev-util/distbox-solidfire-1.2
	=dev-util/gperftools-solidfire-2.1-r1
	=net-dns/c-ares-1.10.0
	=net-libs/libmicrohttpd-solidfire-0.9.32-r2
	=net-libs/soap-solidfire-2.0-r1
	=net-misc/curl-solidfire-7.32.0-r1
	sys-apps/dmidecode
	>=sys-apps/hdparm-9.43
	sys-apps/iproute2
	=sys-apps/lshw-solidfire-02.16b-r5
	=sys-cluster/zookeeper-solidfire-3.5.0-r19
	>=sys-devel/gdb-7.6.2
	=sys-libs/libunwind-solidfire-1.1-r4
	=www-servers/pion-solidfire-5.0.0-r6"

DEPEND="${RDEPEND}"
