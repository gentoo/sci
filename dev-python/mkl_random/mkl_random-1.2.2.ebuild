# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python interface to Intel Math Kernel Library's random number generation"
HOMEPAGE="https://github.com/IntelPython/mkl_random"
SRC_URI="https://github.com/IntelPython/mkl_random/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	sys-devel/DPC++
"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/mkl
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_prepare_all() {
	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"
	export DPCPPROOT="${ESYSROOT}/usr/lib/llvm/intel"
	export MKLROOT="${ESYSROOT}/opt/intel/oneapi/mkl/latest"
	export C_INCLUDE_PATH="${ESYSROOT}/opt/intel/oneapi/mkl/latest/include/"
	export CPLUS_INCLUDE_PATH="${ESYSROOT}/opt/intel/oneapi/mkl/latest/include/"

	distutils-r1_python_prepare_all
}
