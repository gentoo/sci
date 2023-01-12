# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Data Parallel Control "
HOMEPAGE="https://github.com/IntelPython/dpctl"
SRC_URI="https://github.com/IntelPython/dpctl/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/scikit-build[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/versioneer[${PYTHON_USEDEP}]
	dev-util/cmake
	dev-vcs/git
	sys-devel/DPC++
"

DEPEND="
	dev-libs/level-zero
	dev-libs/opencl-icd-loader
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	sci-libs/oneDAL
	sys-devel/DPC++:0/5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.14.0-dont-fetch-level-zero.patch"
	"${FILESDIR}/${PN}-0.13.0-dont-fetch-pybind.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"
	export DPCPPROOT="${ESYSROOT}/usr/lib/llvm/intel"

	# For some reason this is required to build successfully
	mkdir -p _skbuild/linux-x86_64-3.8/setuptools/lib.linux-x86_64-cpython-38/dpctl || die
	cp dpctl/_version.py _skbuild/linux-x86_64-3.8/setuptools/lib.linux-x86_64-cpython-38/dpctl || die
	mkdir -p _skbuild/linux-x86_64-3.9/setuptools/lib.linux-x86_64-cpython-39/dpctl || die
	cp dpctl/_version.py _skbuild/linux-x86_64-3.9/setuptools/lib.linux-x86_64-cpython-39/dpctl || die
	mkdir -p _skbuild/linux-x86_64-3.10/setuptools/lib.linux-x86_64-cpython-310/dpctl || die
	cp dpctl/_version.py _skbuild/linux-x86_64-3.10/setuptools/lib.linux-x86_64-cpython-310/dpctl || die
	mkdir -p _skbuild/linux-x86_64-3.11/setuptools/lib.linux-x86_64-cpython-311/dpctl || die
	cp dpctl/_version.py _skbuild/linux-x86_64-3.11/setuptools/lib.linux-x86_64-cpython-311/dpctl || die

	distutils-r1_python_prepare_all
}
