# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils git-r3

DESCRIPTION="A general purpose GPU library."
HOMEPAGE="http://www.arrayfire.com/"
EGIT_REPO_URI="https://github.com/arrayfire/arrayfire.git"
KEYWORDS="~amd64"

LICENSE="ArrayFire"
SLOT="0"
IUSE="+examples +cpu cuda independent test"

RDEPEND="
	>=sys-devel/gcc-4.7.3-r1
	virtual/blas
	virtual/cblas
	cuda? ( >=dev-util/nvidia-cuda-toolkit-6.0 )
	sci-libs/fftw:3.0"
DEPEND="${RDEPEND}
	test? ( dev-vcs/subversion )"

S="${WORKDIR}/${P}"
BUILD_DIR="${S}/build"
CMAKE_BUILD_TYPE=Release

src_prepare() {
	if use cpu; then
		epatch "${FILESDIR}/FindCBLAS.patch"
	fi
	if use examples; then
		epatch "${FILESDIR}/CMakeLists_examples.patch"
	fi

	cmake-utils_src_prepare
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

	exeinto /usr/bin
	doexe "build/bin2cpp"
}
