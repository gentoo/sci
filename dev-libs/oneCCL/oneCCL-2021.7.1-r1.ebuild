# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="oneAPI Collective Communications Library"
HOMEPAGE="https://github.com/oneapi-src/oneCCL"
SRC_URI="https://github.com/oneapi-src/oneCCL/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="mpi"

BDEPEND="sys-devel/DPC++"

DEPEND="
	dev-libs/level-zero:=
	sys-apps/hwloc:=
	sys-block/libfabric:=
	sys-devel/ittapi
	mpi? ( virtual/mpi )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2021.7.1-use-system-libs.patch"
)

src_prepare() {
	# No -Werror
	find . -name "CMakeLists.txt" -exec sed -i "s/-Werror//g" {} + || die

	# Use system libs instead
	rm -r deps/* || die

	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		# BUILD_CONFIG causes sandbox violation
		-DBUILD_CONFIG=OFF
		-DCCL_ENABLE_ZE=ON
		# TODO: Find out how to execute the tests
		-DBUILD_FT=OFF
		-DENABLE_MPI_TESTS=OFF
		-DENABLE_MPI="$(usex mpi)"
		# Use system fabric
		-DLIBFABRIC_DIR="${ESYSROOT}/usr"
	)
	cmake_src_configure
}
