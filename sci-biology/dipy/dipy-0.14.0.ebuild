# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Computational neuroanatomy project focusing on diffusion MRI"
HOMEPAGE="http://nipy.org/dipy"
SRC_URI="https://github.com/nipy/dipy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	sci-libs/nibabel[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

# Tests for this release fail: https://github.com/nipy/dipy/issues/1531
RESTRICT="test"

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	nosetests || die
}
