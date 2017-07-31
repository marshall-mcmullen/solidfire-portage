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
	dev-perl/XML-LibXML-Simple"

ENVD_FILE="05${PF}"
SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/etc" "/etc/env.d" "/etc/env.d/${ENVD_FILE}" )

src_unpack()
{
	mkdir -p ${S}
}

src_install()
{
	dobin ${FILESDIR}/xml2json

	cat > "${T}/${ENVD_FILE}" <<-EOF
	PATH="/sf/packages/${PF}/bin"
	ROOTPATH="/sf/packages/${PF}/bin"
	EOF
	doenvd "${T}/${ENVD_FILE}"
}
