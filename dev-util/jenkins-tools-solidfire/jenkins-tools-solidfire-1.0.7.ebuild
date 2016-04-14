# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit jenkins-tools-solidfire

DESCRIPTION="Tools for interacting with a jenkins server from the command line."
HOMEPAGE="http://solidfire.com"
SRC_URI="${MY_PF}.tgz"

DEPEND="=dev-util/bashutils-solidfire-1.3.25
		virtual/jre
		net-misc/curl
		net-misc/openssh
		app-text/xmlstarlet
		app-misc/jq"
