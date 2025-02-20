# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_11 )

inherit distutils-r1

DESCRIPTION="Computational neuroanatomy project focusing on diffusion MRI"
HOMEPAGE="https://github.com/nipy/dipy"
SRC_URI="https://github.com/nipy/dipy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	sci-libs/nibabel[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

# Tests fail because they require data download:
# https://github.com/dipy/dipy/issues/2092
RESTRICT="test"

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	pytest -m "not network" || die
}
