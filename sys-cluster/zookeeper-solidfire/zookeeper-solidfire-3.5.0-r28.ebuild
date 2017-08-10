# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jemalloc/jemalloc-3.6.0.ebuild,v 1.1 2014/05/19 14:09:08 anarchy Exp $

EAPI=5
inherit java-pkg-2 zookeeper-solidfire

DESCRIPTION="ZooKeeper is a distributed, open-source coordination service for distributed applications."
HOMEPAGE="http://zookeeper.apache.org/"
SRC_URI="https://bitbucket.org/solidfire/${MY_PN}/get/solidfire/${PVR}.tar.bz2 -> ${PF}.tar.bz2"

LICENSE="Apache-2.0"
KEYWORDS="amd64 ~amd64"

RDEPEND=">=virtual/jre-1.8"
DEPEND="dev-java/ant-core
	dev-libs/boost
	dev-libs/libxml2
	dev-libs/log4cxx
	dev-util/cppunit
	>=virtual/jdk-1.8"
