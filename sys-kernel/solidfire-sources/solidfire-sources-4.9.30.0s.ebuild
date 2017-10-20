# Copyright 2017 NetApp, Inc.  All rights reserved.

EAPI="5"
ETYPE="sources"
inherit solidfire-kernel

DESCRIPTION="Full sources for the Linux kernel with SolidFire patches"
HOMEPAGE="https://solidfire.com"
SRC_URI="https://bitbucket.org/solidfire/solidfire-kernel/get/v${KVERSION}-solidfire${SFVERSION}.tar.bz2 -> ${PF}.tar.bz2"
KEYWORDS="amd64"
