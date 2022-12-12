# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Seamless way to speed up your Scikit-learn application"
HOMEPAGE="https://github.com/intel/scikit-learn-intelex"
SRC_URI="https://github.com/intel/scikit-learn-intelex/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/scikit-learn-intelex-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/daal4py[${PYTHON_USEDEP}]
	sci-libs/scikit-learn[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

python_prepare_all() {
	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"
	export DPCPPROOT="${ESYSROOT}/usr/lib/llvm/intel"
	export CPLUS_INCLUDE_PATH="${ESYSROOT}/usr/lib/llvm/intel/include:${ESYSROOT}/usr/lib/llvm/intel/include/sycl"
	export MPIROOT="${ESYSROOT}/usr"
	export DALROOT="${ESYSROOT}/usr"

	# remove the daal4py setup files, and rename skleanex setup files
	rm setup.py setup.cfg || die
	mv setup_sklearnex.cfg setup.cfg || die
	mv setup_sklearnex.py setup.py || die

	distutils-r1_python_prepare_all
}
