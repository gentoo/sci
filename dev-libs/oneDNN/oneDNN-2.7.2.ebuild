# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="${WORKDIR}/${P}_build"
# There is additional sphinx documentation but we are missing dependency doxyrest.
inherit cmake docs

DESCRIPTION="oneAPI Deep Neural Network Library"
HOMEPAGE="https://github.com/oneapi-src/oneDNN"
SRC_URI="https://github.com/oneapi-src/oneDNN/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
# TODO: get the tests up and running
#RESTRICT="!test? ( test )"
RESTRICT="test"

BDEPEND="sys-devel/DPC++"

DEPEND="
	dev-cpp/tbb:=
	dev-libs/level-zero:=
	virtual/opencl
"
RDEPEND="${DEPEND}"

src_prepare() {
	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDNNL_CPU_RUNTIME=DPCPP
		-DDNNL_GPU_RUNTIME=DPCPP
		-DDNNL_BUILD_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	docs_compile
}

src_install() {
	cmake_src_install
	# Correct docdir
	mv "${ED}/usr/share/doc/dnnl/"* "${ED}/usr/share/doc/${PF}" || die
	rm -r "${ED}/usr/share/doc/dnnl" || die
}
