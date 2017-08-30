# Copyright 2014 SolidFire, Inc.
# $Header: $

EAPI=5
inherit solidfire-libs

DESCRIPTION="Convert XML to JSON."
HOMEPAGE="http://solidfire.com"
SRC_URI=

LICENSE="public-domain"
KEYWORDS="amd64 ~amd64"
RDEPEND="dev-perl/JSON-Any
	dev-perl/XML-Simple"

SOLIDFIRE_EXPORT_PATH="/sf/packages/${PF}/bin"

src_unpack()
{
	mkdir -p ${S}
}

src_install()
{
	dobin ${FILESDIR}/xml2json
}
