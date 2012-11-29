# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils

MY_P="${PN^^[om]}${PV}-Source"
DESCRIPTION="provides tools for modern molecular modeling simulation"
HOMEPAGE="https://simtk.org/home/openmm"
SRC_URI="${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda opencl"

RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )
	opencl? ( virtual/opencl )"
DEPEND="${RDEPEND}
	dev-util/cmake"

RESTRICT="fetch"
S="${WORKDIR}/${MY_P}"

pkg_nofetch(){
	einfo "Please download ${SRC_URI} from"
	einfo "${HOMEPAGE}"
	einfo "and put it into ${DISTDIR}"
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use opencl OPENMM_BUILD_RPMD_PLUGIN)
		$(cmake-utils_use opencl OPENMM_BUILD_PYTHON_WRAPPERS)
	) # workarounds for broken autodetection

	cmake-utils_src_configure
}
