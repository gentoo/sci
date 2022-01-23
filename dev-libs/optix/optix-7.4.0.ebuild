# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NVIDIA Ray Tracing Engine"
HOMEPAGE="https://developer.nvidia.com/optix"
SRC_URI="NVIDIA-OptiX-SDK-${PV}-linux64-x86_64.sh"
S="${WORKDIR}"

SLOT="0/7"
KEYWORDS="~amd64"
RESTRICT="fetch mirror"
LICENSE="NVIDIA-r2"

RDEPEND="
	dev-util/nvidia-cuda-toolkit:=
	media-libs/freeglut
	virtual/opengl
"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTDIR directory."
	einfo 'DISTDIR value is available from `emerge --info`'
}

src_unpack() {
	tail -n +223 "${DISTDIR}"/${A} | tar -zx || die
}

src_install() {
	insinto /opt/${PN}
	dodoc -r doc
	doins -r include SDK
}
