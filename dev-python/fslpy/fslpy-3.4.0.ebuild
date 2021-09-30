# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 virtualx

DESCRIPTION="The FSL Python Library"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fslpy"
SRC_URI="https://github.com/pauldmccarthy/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/indexed_gzip[${PYTHON_USEDEP}]
	=dev-python/numpy-1*[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	=dev-python/six-1*[${PYTHON_USEDEP}]
	dev-python/trimesh[${PYTHON_USEDEP}]
	=dev-python/wxpython-4*[${PYTHON_USEDEP}]
	sci-libs/rtree[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-2.3.1[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/fslpy-2.7.0-coverage.patch"
	"${FILESDIR}/fslpy-3-remove_dataclasses_req.patch"
)

distutils_enable_tests pytest

python_test() {
	virtx pytest --niters=50 -m "not (dicomtest or longtest or fsltest)" --verbose || die
}
