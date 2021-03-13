# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="AMD's Machine Intelligence Library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpen/archive/rocm-${PV}.tar.gz -> MIOpen-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	>=dev-util/hip-${PV}
	>=dev-libs/half-1.12.0
	<dev-libs/half-2
	dev-libs/ocl-icd
	=dev-util/rocm-clang-ocl-${PV}*
	sci-libs/rocBLAS
	=dev-libs/boost-1.72*"

DEPEND="${RDEPEND}"
BDEPEND="app-admin/chrpath"

S="${WORKDIR}/MIOpen-rocm-${PV}"

src_prepare() {
	sed -e "s:PATHS /opt/rocm/llvm:PATHS ""${EPREFIX}""/usr/lib/llvm/roc/ NO_DEFAULT_PATH:" \
		-e '/set( MIOPEN_INSTALL_DIR/s:miopen:${CMAKE_INSTALL_PREFIX}:' \
		-e '/set(MIOPEN_SYSTEM_DB_PATH/s:${CMAKE_INSTALL_PREFIX}/::' \
		-e '/MIOPEN_TIDY_ERRORS ALL/d' \
		-i CMakeLists.txt || die

	sed -e "/rocm_install_symlink_subdir(\${MIOPEN_INSTALL_DIR})/d" -i src/CMakeLists.txt || die

	sed -e "s:\${AMD_DEVICE_LIBS_PREFIX}/lib:${EPREFIX}/usr/lib/amdgcn/bitcode:" -i cmake/hip-config.cmake || die

	cmake_src_prepare
}

src_configure() {
	export CXX="hipcc"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_BUILD_TYPE=Release
		-DMIOPEN_BACKEND=HIP
		-DBoost_USE_STATIC_LIBS=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	chrpath --delete "${ED}/usr/bin/MIOpenDriver" || die
	chrpath --delete "${ED}/usr/lib64/libMIOpen.so.1.0" || die
}
