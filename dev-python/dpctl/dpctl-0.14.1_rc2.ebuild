# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Data Parallel Control "
HOMEPAGE="https://github.com/IntelPython/dpctl"
SRC_URI="https://github.com/IntelPython/dpctl/archive/refs/tags/${PV//_rc/dev}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${PV//_rc/dev}"

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
	sys-devel/DPC++:0/6
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.14.0-find-opencl.patch"
	"${FILESDIR}/${PN}-0.14.1_rc2-dont-fetch-level-zero.patch"
	"${FILESDIR}/${PN}-0.14.1_rc2-dont-fetch-pybind.patch"
	#"${FILESDIR}/${PN}-0.14.1_rc2-include-tuple.patch"
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

python_test() {
	export PYTHONPATH="${BUILD_DIR}/install/usr/lib/${EPYTHON}/site-packages"
	# We don't use epytest because it overwrites our PYTHONPATH
	pytest -vv || die
}
