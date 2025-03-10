# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda

DESCRIPTION="Gradient boosting framework (GBM) based on decision tree algorithms"
HOMEPAGE="https://github.com/microsoft/LightGBM"
SRC_URI="https://github.com/microsoft/LightGBM/archive/refs/tags/v${PV}.tar.gz -> LightGBM-${PV}.tar.gz
	https://github.com/boostorg/compute/archive/36350b7d.tar.gz -> compute-36350b7d.tar.gz
	https://github.com/google/double-conversion/archive/f4cb2384.tar.gz -> double-conversion-f4cb2384.tar.gz
	https://github.com/lemire/fast_double_parser/archive/efec0353.tar.gz -> fast_double_parser-efec0353.tar.gz
	https://github.com/fmtlib/fmt/archive/f5e54359.tar.gz -> fmt-f5e54359.tar.gz"
S="${WORKDIR}/LightGBM-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda"

RDEPEND="cuda? ( >=dev-util/nvidia-cuda-toolkit-11 )"
DEPEND=">=dev-cpp/eigen-3.4"

PATCHES=( "${FILESDIR}"/${PN}-4.5.0-eigen3.patch
	"${FILESDIR}"/${PN}-4.5.0-libdir.patch )

src_prepare() {
	rmdir external_libs/compute && ln -sv "${WORKDIR}"/compute-36350b7de849300bd3d72a05d8bf890ca405a014 external_libs/compute || die
	rmdir external_libs/fast_double_parser/benchmarks/dependencies/double-conversion && ln -sv "${WORKDIR}"/double-conversion-f4cb2384efa55dee0e6652f8674b05763441ab09 external_libs/fast_double_parser/benchmarks/dependencies/double-conversion || die
	rmdir external_libs/fast_double_parser && ln -sv "${WORKDIR}"/fast_double_parser-efec03532ef65984786e5e32dbc81f6e6a55a115 external_libs/fast_double_parser || die
	rmdir external_libs/fmt && ln -sv "${WORKDIR}"/fmt-f5e54359df4c26b6230fc61d38aa294581393084 external_libs/fmt || die
	cmake_src_prepare
	use cuda && cuda_src_prepare
}

src_configure() {
	local mycmakeargs=()
	if use cuda; then
		# Host compiler should also be nvcc compatible,
		# or error occur in the final linking
		# CMakeLists also ensures that, so configure fails if we just set CMAKE_CUDA_FLAGS
		PATH="$(cuda_gccdir):${PATH}"
		mycmakeargs+=(
			-DUSE_CUDA=ON
		)
	fi
	cmake_src_configure
}
