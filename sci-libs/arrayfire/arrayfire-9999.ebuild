# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-r3

GTEST_PV="1.7.0"

DESCRIPTION="A general purpose GPU library."
HOMEPAGE="http://www.arrayfire.com/"
EGIT_REPO_URI="https://github.com/arrayfire/arrayfire.git git://github.com/arrayfire/arrayfire.git"
SRC_URI="test? ( https://googletest.googlecode.com/files/gtest-${GTEST_PV}.zip )"
KEYWORDS=""
if [[ ${PV} == "0.9999" ]] ; then
	# the remote HEAD points to devel, but we want to pull the master instead
	EGIT_BRANCH="master"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+examples +cpu cuda test"

RDEPEND="
	>=sys-devel/gcc-4.7.3-r1
	virtual/blas
	virtual/cblas
	cuda? ( >=dev-util/nvidia-cuda-toolkit-6.0 )
	sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"

BUILD_DIR="${S}/build"
CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}"/FindCBLAS.patch
	"${FILESDIR}"/CMakeLists_examples.patch
	"${FILESDIR}"/build_gtest.patch
)

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
	   $(cmake-utils_use_build cpu CPU)
	   $(cmake-utils_use_build cuda CUDA)
	   -DBUILD_OPENCL=OFF
	   $(cmake-utils_use_build examples EXAMPLES)
	   $(cmake-utils_use_build test TEST)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dobin "bin2cpp"
}
