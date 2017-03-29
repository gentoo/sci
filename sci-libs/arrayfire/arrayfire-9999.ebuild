# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3 multilib

GTEST_PV="1.7.0"

DESCRIPTION="A general purpose GPU library"
HOMEPAGE="http://www.arrayfire.com/"
SRC_URI="test? ( https://github.com/google/googletest/archive/release-${GTEST_PV}.zip -> gtest-${GTEST_PV}.zip )"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git git://github.com/${PN}/${PN}.git"

LICENSE="
	BSD
	nonfree? ( OpenSIFT )"
SLOT="0"
IUSE="+examples +cpu cuda nonfree opencl test unified graphics"
KEYWORDS=""

RDEPEND="
	>=sys-devel/gcc-4.7:*
	media-libs/freeimage
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-7.5.18-r1
		dev-libs/boost
	)
	cpu? (
		virtual/blas
		virtual/cblas
		virtual/lapacke
		sci-libs/fftw:3.0
	)
	opencl? (
		virtual/blas
		virtual/cblas
		virtual/lapacke
		>=sci-libs/clblas-2.4
		>=sci-libs/clfft-2.6.1
		dev-libs/boost
		|| ( dev-libs/boost-compute >=dev-libs/boost-1.61.0 )
	)
	graphics? (
		media-libs/glew:=
		>=media-libs/glfw-3.1.1
		~sci-visualization/forge-3.2.2
	)"
DEPEND="${RDEPEND}"

BUILD_DIR="${S}/build"
CMAKE_BUILD_TYPE=Release

# We need write acccess /dev/nvidiactl, /dev/nvidia0 and /dev/nvidia-uvm and the portage
# user is (usually) not in the video group
RESTRICT="userpriv"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) -lt 4 ]] || ( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) ; then
			die "Compilation with gcc older than 4.7 is not supported."
		fi
	fi
}

src_unpack() {
	git-r3_src_unpack

	if ! use nonfree; then
		find "${WORKDIR}" -name "*_nonfree*" -delete || die
	fi

	if use test; then
		mkdir -p "${BUILD_DIR}"/third_party/src/ || die
		cd "${BUILD_DIR}"/third_party/src/ || die
		unpack ${A}
		mv "${BUILD_DIR}"/third_party/src/gtest-"${GTEST_PV}" "${BUILD_DIR}"/third_party/src/googletest || die
	fi
}

src_configure() {
	if use cuda; then
		addwrite /dev/nvidiactl
		addwrite /dev/nvidia0
		addwrite /dev/nvidia-uvm
	fi

	local mycmakeargs=(
		-DBUILD_CPU="$(usex cpu)"
		-DBUILD_CUDA="$(usex cuda)"
		-DBUILD_OPENCL="$(usex opencl)"
		-DBUILD_EXAMPLES="$(usex examples)"
		-DBUILD_TEST="$(usex test)"
		-DBUILD_GRAPHICS="$(usex graphics)"
		-DBUILD_NONFREE="$(usex nonfree)"
		-DBUILD_UNIFIED="$(usex unified)"
		-DUSE_SYSTEM_BOOST_COMPUTE=ON
		-DUSE_SYSTEM_CLBLAS=ON
		-DUSE_SYSTEM_CLFFT=ON
		-DUSE_SYSTEM_FORGE=ON
		-DAF_INSTALL_CMAKE_DIR=/usr/$(get_libdir)/cmake/ArrayFire
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dobin "${BUILD_DIR}/bin2cpp"
}
