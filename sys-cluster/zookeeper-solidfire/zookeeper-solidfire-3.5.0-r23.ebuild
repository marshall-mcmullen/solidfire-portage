# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jemalloc/jemalloc-3.6.0.ebuild,v 1.1 2014/05/19 14:09:08 anarchy Exp $

EAPI=5
inherit zookeeper-solidfire

DESCRIPTION="ZooKeeper is a distributed, open-source coordination service for distributed applications."
HOMEPAGE="http://zookeeper.apache.org/"
ESVN_REPO_URI="https://svn.apache.org/repos/asf/zookeeper/trunk@1547702"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ~amd64"

DEPEND="dev-java/ant-core
	dev-libs/libxml2
	dev-libs/log4cxx
	dev-util/cppunit
	dev-vcs/subversion
	=dev-java/icedtea-bin-solidfire-7.2.6.2
	=dev-libs/boost-solidfire-1.57.0-r2
	=sys-devel/gcc-solidfire-4.8.1"

PATCHES="case-120.patch
	case-3869.patch
	case-5569.patch
	ZOOKEEPER-1167.patch
	ZOOKEEPER-1520.patch
	ZOOKEEPER-1366.patch
	ZOOKEEPER-1626.patch
	case-13068.patch
	case-13399.patch
	ZOOKEEPER-1865-nanoTime.patch
	ZOOKEEPER-1863.patch"
