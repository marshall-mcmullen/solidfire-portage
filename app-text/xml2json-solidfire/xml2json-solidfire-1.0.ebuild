# Copyright 2014 SolidFire, Inc.
# $Header: $

EAPI=5
inherit solidfire

DESCRIPTION="Convert XML to JSON."
HOMEPAGE="http://solidfire.com"
SRC_URI=

LICENSE="public-domain"
KEYWORDS="amd64 ~amd64"
DEPEND="dev-perl/JSON-Any
	dev-perl/XML-LibXML-Simple"

src_unpack()
{
	mkdir -p ${S}
}

src_install()
{
	dobin ${FILESDIR}/xml2json
}
