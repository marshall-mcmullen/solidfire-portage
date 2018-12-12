# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI=5
inherit zookeeper-solidfire

DESCRIPTION="ZooKeeper is a distributed, open-source coordination service for distributed applications."
HOMEPAGE="http://zookeeper.apache.org/"
SRC_URI="https://bitbucket.org/solidfire/${UPSTREAM_PN}/get/solidfire/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Apache-2.0"
KEYWORDS="amd64 ~amd64"

RDEPEND=">=virtual/jre-1.8"
DEPEND="dev-java/ant-core
	dev-libs/boost
	dev-libs/libxml2
	dev-libs/log4cxx
	dev-util/cppunit
	>=virtual/jdk-1.8"
