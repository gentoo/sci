# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT="f4866ab2648cd7cff4a047b91be5f94ff7b73ba1"

DESCRIPTION="oneAPI Math Kernel Library Interfaces "
HOMEPAGE="https://github.com/oneapi-src/oneMKL"
SRC_URI="https://github.com/oneapi-src/oneMKL/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
# Tests don't compile properly
# RESTRICT="!test? ( test )"
RESTRICT="test"

BDEPEND="sys-devel/DPC++"

DEPEND="
	dev-cpp/tbb:=
	sci-libs/lapack[lapacke]
	sci-libs/mkl
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-find-lapacke.patch"
)

src_prepare() {
	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_COMPILER="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"
		-DCMAKE_C_COMPILER="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
		-DMKL_ROOT="${ESYSROOT}/opt/intel/oneapi/mkl/latest"
		-DBUILD_FUNCTIONAL_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# Move into the correct libdid
	mv "${ED}/usr/lib" "${ED}/usr/$(get_libdir)" || die
}
