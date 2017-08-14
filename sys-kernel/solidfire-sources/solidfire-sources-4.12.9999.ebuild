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

#random cahnge
#EGIT_BRANCH=master
EGIT_COMMIT="7839e71ba4ce521182a4af653a67c6a7e45cb6aa"

src_unpack() {
	git-r3_src_unpack
}
