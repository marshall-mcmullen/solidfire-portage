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

# fc private branch
EGIT_BRANCH=fcnode
EGIT_COMMIT="8c386a30c42db54a7caf747537cb7f904ce93615"

src_unpack() {
	git-r3_src_unpack
}
