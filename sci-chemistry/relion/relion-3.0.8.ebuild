# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Image-processing software for cryo-electron microscopy"
HOMEPAGE="http://www2.mrc-lmb.cam.ac.uk/relion"
SRC_URI="https://github.com/3dem/relion/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gui cuda"

DEPEND="
		gui? ( x11-libs/fltk )
		dev-cpp/tbb
		sci-libs/fftw:3.0
		media-libs/tiff
		virtual/mpi
		cuda? ( dev-util/nvidia-cuda-toolkit )
		"
RDEPEND="
	${DEPEND}
	sci-chemistry/ctffind
	cuda? ( sci-chemistry/MotionCor2 )
"
BDEPEND="${DEPEND}"

src_configure() {
	CMAKE_BUILD_TYPE=Release
	mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DALTCPU=$(usex !cuda)
		-DFORCE_OWN_FFTW=OFF
		-DFORCE_OWN_FLTK=OFF
		-DFORCE_OWN_TBB=OFF
		-DCUDA=$(usex cuda)
		-DGUI=$(usex gui)
	)
	cmake-utils_src_configure
}
