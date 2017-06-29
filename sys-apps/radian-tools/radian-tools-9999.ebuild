# Copyright 2017 Solidfire

EAPI=5
inherit git-r3
inherit solidfire-libs

DESCRIPTION="Radian NVRAM userspace tools"
HOMEPAGE="http://www.radianmemory.com"

# You have to clone the radian-tools repo locally, since it's private
# on bitbucket.  This ebuild tries to clone from:
#     file:///root/radian-tools
EGIT_REPO_URI="file:///root/radian-tools"
EGIT_BRANCH=${SOLIDFIRE_RADIAN_TOOLS_BRANCH:-master}

LICENSE="Radian NDA"
KEYWORDS="~amd64"

DEPEND='dev-libs/libnl'

ENVD_FILE="05${PF}"
SOLIDFIRE_SANDBOX_VIOLATIONS_ALLOWED=( "/etc" "/etc/env.d" "/etc/env.d/${ENVD_FILE}" )

src_install()
{
	emake DESTDIR="${D}" install

	cat > "${T}/${ENVD_FILE}" <<-EOF
	PATH="/sf/packages/${PF}/bin"
	ROOTPATH="/sf/packages/${PF}/bin"
	EOF
	doenvd "${T}/${ENVD_FILE}"
}
