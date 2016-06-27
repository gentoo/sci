# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="computational neuroanatomy project focusing on diffusion MRI"
HOMEPAGE="http://nipy.org/dipy"
SRC_URI="https://github.com/nipy/dipy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	"

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	nosetests || die
}

