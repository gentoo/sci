# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
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
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-find-opencl.patch"
	"${FILESDIR}/${P}-dont-fetch-level-zero.patch"
	"${FILESDIR}/${P}-dont-fetch-pybind.patch"
	"${FILESDIR}/${P}-include-tuple.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# DPC++ compiler required for full functionality
	export CC="${ESYSROOT}/usr/lib/llvm/intel/bin/clang"
	export CXX="${ESYSROOT}/usr/lib/llvm/intel/bin/clang++"
	export DPCPPROOT="${ESYSROOT}/usr/lib/llvm/intel"

	# Build system reads version from git tag
	git init -q || die
	git config --global user.email "larry@gentoo.org" || die
	git config --global user.name "Larry the Cow" || die
	git add . || die
	git commit -qm "init" || die
	git tag -a "${PV}" -m "${PN} version ${PV}" || die

	distutils-r1_python_prepare_all
}
