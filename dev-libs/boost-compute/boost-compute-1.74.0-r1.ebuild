# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A header-only C++ Computing Library for OpenCL"
HOMEPAGE="https://github.com/boostorg/compute"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/boostorg/compute"
else
	SRC_URI="https://github.com/boostorg/compute/archive/boost-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/compute-boost-${PV}
	KEYWORDS="~amd64"
fi

LICENSE="Boost-1.0"
SLOT="0"
IUSE="benchmark bolt cache cpp11 cuda eigen examples opencv qt tbb test threads vtk"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost
	virtual/opencl
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-libdir.patch )

src_configure() {
	local mycmakeargs=(
		-DBOOST_COMPUTE_USE_OFFLINE_CACHE=$(usex cache)
		-DBOOST_COMPUTE_USE_CPP11=$(usex cpp11)
		-DBOOST_COMPUTE_THREAD_SAFE=$(usex threads)
		-DBOOST_COMPUTE_HAVE_EIGEN=$(usex eigen)
		-DBOOST_COMPUTE_HAVE_OPENCV=$(usex opencv)
		-DBOOST_COMPUTE_HAVE_QT=$(usex qt)
		-DBOOST_COMPUTE_HAVE_VTK=$(usex vtk)
		-DBOOST_COMPUTE_HAVE_CUDA=$(usex cuda)
		-DBOOST_COMPUTE_HAVE_TBB=$(usex tbb)
		-DBOOST_COMPUTE_HAVE_BOLT=$(usex bolt)
		-DBOOST_COMPUTE_BUILD_TESTS=$(usex test)
		-DBOOST_COMPUTE_BUILD_BENCHMARKS=$(usex benchmark)
		-DBOOST_COMPUTE_BUILD_EXAMPLES=$(usex examples)
	)
	cmake_src_configure
}
