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
EGIT_COMMIT="c463b5f8de94657c37415a53b61336b7a78837ea"

src_unpack() {
	git-r3_src_unpack
}
