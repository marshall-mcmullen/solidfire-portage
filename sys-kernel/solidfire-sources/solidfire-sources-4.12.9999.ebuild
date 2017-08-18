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
EGIT_COMMIT="6a6d35b45ccb74389be8b025c1c79b73310bcf2f"

src_unpack() {
	git-r3_src_unpack
}
