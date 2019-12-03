# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils cuda

DESCRIPTION="NVIDIA Ray Tracing Engine"
HOMEPAGE="https://developer.nvidia.com/optix"
SRC_URI="NVIDIA-OptiX-SDK-${PV}-linux64-25650775.sh"

SLOT="0/6"
KEYWORDS="~amd64"
RESTRICT="fetch"
LICENSE="NVIDIA-r2"

RDEPEND="dev-util/nvidia-cuda-toolkit
	virtual/opengl
	media-libs/freeglut"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

CMAKE_USE_DIR=${S}/SDK

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTDIR directory."
	einfo 'DISTDIR value is available from `emerge --info`'
}

src_unpack() {
	tail -n +218 "${DISTDIR}"/${A} | tar -zx || die
}

src_prepare() {
	cmake-utils_src_prepare
	rm -rf SDK-precompiled-samples
	export PATH=$(cuda_gccdir):${PATH}
}

src_install() {
	insinto /opt/${PN}
	doins -r doc include lib64
}
