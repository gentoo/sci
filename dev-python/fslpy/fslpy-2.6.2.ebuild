# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1 virtualx

DESCRIPTION="The FSL Python Library"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fslpy"
SRC_URI="https://github.com/pauldmccarthy/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/deprecation[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/indexed_gzip[${PYTHON_USEDEP}]
	=dev-python/numpy-1*[${PYTHON_USEDEP}]
	=dev-python/six-1*[${PYTHON_USEDEP}]
	dev-python/trimesh[${PYTHON_USEDEP}]
	=dev-python/wxpython-4*[${PYTHON_USEDEP}]
	=sci-libs/Rtree-0.8.3*[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-2.3.1[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-exclude_tests.patch" )

python_test() {
	virtx pytest -m "not (dicomtest or fsltest)" --verbose || die
}
