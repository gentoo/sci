# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 virtualx

DESCRIPTION="The FSL Python Library"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fslpy"
SRC_URI="https://git.fmrib.ox.ac.uk/fsl/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/dill[${PYTHON_USEDEP}]
	>=dev-python/h5py-2.9[${PYTHON_USEDEP}]
	>=dev-python/indexed-gzip-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1[${PYTHON_USEDEP}]
	>=dev-python/pillow-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/trimesh-2.37.29[${PYTHON_USEDEP}]
	=dev-python/wxpython-4*[${PYTHON_USEDEP}]
	>=dev-python/rtree-0.8.3[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-2.4[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.18[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinx-rtd-theme

python_prepare_all() {
	# Do not depend on coverage
	sed -i -e 's/--cov=fsl//g' setup.cfg || die

	distutils-r1_python_prepare_all
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	epytest -m "not (dicomtest or longtest or fsltest)" || die "Tests failed with ${EPYTHON}"
}
