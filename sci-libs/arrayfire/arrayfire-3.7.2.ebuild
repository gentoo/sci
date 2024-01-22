# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="general purpose GPU library"
HOMEPAGE="https://arrayfire.com/"
SRC_URI="https://github.com/arrayfire/arrayfire/releases/download/v${PV}/${PN}-full-${PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}"/${PN}-full-${PV}
BUILD_DIR="${S}/build"

KEYWORDS="~amd64"

LICENSE="BSD nonfree? ( OpenSIFT )"
SLOT="0"
IUSE="examples +cache cuda doc mkl nonfree opencl test +trace"
RESTRICT="bindist mirror !test? ( test )"

RDEPEND="
	media-libs/freeimage
	media-libs/glbinding
	>=media-libs/glfw-3.1
	~sci-visualization/forge-1.0.5
	virtual/blas
	virtual/cblas
	virtual/lapacke
	sci-libs/fftw:3.0
	cuda? (
		dev-libs/cudnn
		>=dev-util/nvidia-cuda-toolkit-9.0.0
		>=dev-libs/boost-1.70.0
	)
	mkl? (
	     sci-libs/mkl
	)
	opencl? (
		>=dev-libs/boost-1.70.0
		>=sci-libs/clblas-2.4
		>=sci-libs/clfft-2.6.1
		virtual/opencl
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-text/doxygen )
	virtual/pkgconfig
"

src_unpack() {
	default

	if ! use nonfree; then
		find "${WORKDIR}" -name "*_nonfree*" -delete || die
	fi
}

src_configure() {
	if use cuda; then
		addwrite /dev/nvidiactl
		addwrite /dev/nvidia0
		addwrite /dev/nvidia-uvm
	fi

	# forge headers are needed, so submodule
	# has to stay, hence a ~ on forge dependency
	local mycmakeargs=(
		-DAF_BUILD_CPU=ON
		-DAF_BUILD_CUDA="$(usex cuda)"
		-DAF_BUILD_OPENCL="$(usex opencl)"
		-DAF_BUILD_UNIFIED=ON
		-DAF_BUILD_DOCS="$(usex doc)"
		-DAF_BUILD_EXAMPLES="$(usex examples)"
		-DAF_WITH_CUDNN="$(usex cuda)"
		-DAF_BUILD_FORGE=OFF
		-DAF_WITH_NONFREE="$(usex nonfree)"
		-DAF_WITH_LOGGING=ON
		-DAF_WITH_STACKTRACE="$(usex trace)"
		-DAF_CACHE_KERNELS_TO_DISK="$(usex cache)"
		-DAF_WITH_STATIC_MKL="$(usex mkl)"
		-DAF_INSTALL_STANDALONE=OFF
		-DAF_WITH_STATIC_FREEIMAGE=OFF
		-DAF_INSTALL_CMAKE_DIR=/usr/$(get_libdir)/cmake/ArrayFire
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc -r "${ED}"/usr/LICENSES
	rm -r "${ED}"/usr/LICENSES || die

	dobin "${BUILD_DIR}"/bin2cpp
}
