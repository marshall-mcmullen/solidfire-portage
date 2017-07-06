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

#EGIT_BRANCH=master
EGIT_COMMIT="v4.11.7-solidfire2"

src_unpack() {
	git-r3_src_unpack
}
