# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 virtualx

DESCRIPTION="The FSL Python Library"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fslpy"
SRC_URI="https://git.fmrib.ox.ac.uk/fsl/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/h5py-2.9[${PYTHON_USEDEP}]
	>=dev-python/indexed_gzip-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1[${PYTHON_USEDEP}]
	>=dev-python/pillow-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/trimesh-2.37.29[${PYTHON_USEDEP}]
	=dev-python/wxpython-4*[${PYTHON_USEDEP}]
	>=sci-libs/rtree-0.8.3[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-2.4[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.18[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/fslpy-2.7.0-coverage.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinx_rtd_theme

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	epytest --niters=50 -m "not (dicomtest or longtest or fsltest)" || die "Tests failed with ${EPYTHON}"
}
