# Copyright 2017-2018 NetApp, Inc. All rights reserved.

EAPI=5

inherit solidfire

DESCRIPTION="SolidFire Drive Automation Test Environment (SF-DATE)"
HOMEPAGE="https://bitbucket.org/solidfire/sf-date"
SRC_URI="https://bitbucket.org/solidfire/sf-date/get/release/${PV}.tar.bz2 -> sf-date-${PV}.tar.bz2"

LICENSE="NetApp"
KEYWORDS="amd64"

DEPEND=""

RDEPEND="dev-lang/python
         sys-block/fio
         sys-block/lsiutil
         sys-apps/sg3_utils"

src_install()
{
    set -e
    doins -r ${S}/*
}

src_compile() { :; }
