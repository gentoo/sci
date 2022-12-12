# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Data Parallel Extension for Numba"
HOMEPAGE="https://github.com/IntelPython/numba-dpex"
SRC_URI="https://github.com/IntelPython/numba-dpex/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	sys-devel/DPC++
"

RDEPEND="
	dev-python/dpctl[${PYTHON_USEDEP}]
	dev-python/dpnp[${PYTHON_USEDEP}]
	dev-python/numba[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_prepare_all() {
	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"
	export DPCPPROOT="${ESYSROOT}/usr/lib/llvm/intel"

	distutils-r1_python_prepare_all
}
