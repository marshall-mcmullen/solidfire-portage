# Copyright 2018 Netapp
#
# The process for updating to a new version of the mnode-svc-auth image
# is this:
#
#     docker save -o mnode-svc-auth-${VERSION}.tar.gz docker.sqd.solidfire.net:9000/mnode-svc-auth:${VERSION}
#
#     put the saved image tarball in ember/work/distfiles
#
#     copy this ebuild to ember/portage/sys-auth/mnode-svc-auth/mnode-svc-auth-${VERSION}.ebuild, no changes needed
#
#     make manifest
#
#     make publish-distfiles
#
#
# To load the image into a running docker daemon:
#
#     docker load --input="${PREFIX}/${P}.tar.gz"
#


EAPI=5

inherit eutils solidfire

DESCRIPTION="Management Node Authentication Service container"
HOMEPAGE="http://www.netapp.com"

DOCKER_SERVER="docker.sqd.solidfire.net:9000"
IMAGE_NAME="${PN#solidfire-}"
IMAGE_FULL_NAME="${DOCKER_SERVER}/${IMAGE_NAME}:${PV}"

# SRC_URI is not the real URI of the image distfile, it's a hack to
# trick portage into finding the distfile that is manually copied from
# the Solidfire docker repository to the Ember distfile cache.
SRC_URI="${DOCKER_SERVER}/${IMAGE_NAME}-${PV}.tar.gz"

LICENSE="NetApp"
KEYWORDS="amd64"

DEPEND="app-emulation/docker"
RDEPEND="${DEPEND}"


src_install() {
	mkdir -p "${DP}"
	cp "${DISTDIR}/${IMAGE_NAME}-${PV}.tar.gz" "${DP}"
}


pkg_prerm() {
	IMAGE_ID=$(docker image ls --quiet "${IMAGE_FULL_NAME}")
	if [[ -z "${IMAGE_ID}" ]]; then
		einfo "Nothing to remove: ${IMAGE} not found!"
		return 0
	fi

	CONTAINERS=$(docker ps --all --filter "ancestor=${IMAGE_ID}" --quiet)
	if [[ -n "${CONTAINERS}" ]]; then
		for CONTAINER in ${CONTAINERS}; do
			einfo "Removing container ${CONTAINER}"
			docker rm --force "${CONTAINER}"
		done
	fi

	einfo "Removing image ${IMAGE_FULL_NAME}"
	docker image rm "${IMAGE_ID}"
}
