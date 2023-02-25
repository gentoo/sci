# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
# Breaks library installation
#DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Data Parallel Extension for NumPy"
HOMEPAGE="https://github.com/IntelPython/dpnp"
SRC_URI="https://github.com/IntelPython/dpnp/archive/refs/tags/${PV//_rc/dev}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${PV//_rc/dev}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-util/cmake
	sys-devel/DPC++
"

RDEPEND="
	dev-cpp/tbb
	dev-python/dpctl[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/mkl
	sys-devel/DPC++:=
"
DEPEND="${RDEPEND}
	sys-devel/oneDPL
"

PATCHES=(
	"${FILESDIR}/${P}-fix-compile.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"
	export DPCPPROOT="${ESYSROOT}/usr/lib/llvm/intel"
	export DPL_ROOT="${ESYSROOT}/usr/include/include/oneapi/dpl"
	# Parallel build broken
	export MAKEOPTS="-j1"

	distutils-r1_python_prepare_all
}

python_compile() {
	export BUILD_DIR_LIBS="${BUILD_DIR}/lib/dpnp"
	distutils-r1_python_compile
}

python_test() {
	export PYTHONPATH="${BUILD_DIR}/lib"
	elog $PYTHONPATH
	# We don't use epytest because it overwrites our PYTHONPATH
	pytest -vv || die
}
