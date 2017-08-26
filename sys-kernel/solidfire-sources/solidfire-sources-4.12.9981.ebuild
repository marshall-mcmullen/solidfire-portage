EAPI="5"
ETYPE="sources"
inherit kernel-2
inherit git-r3
detect_version
detect_arch

KEYWORDS="amd64"
HOMEPAGE="https://solidfire.com"

DESCRIPTION="Full sources for the Linux kernel with Solidfire patches"

EGIT_REPO_URI="https://bitbucket.org/solidfire/solidfire-kernel"
EGIT_CHECKOUT_DIR="${S}"

EGIT_BRANCH=fcnode
EGIT_COMMIT="7169624bdb65547b734cb15c8fc31959024f35a6"

src_unpack() {
	git-r3_src_unpack
}
