# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Python package to access BIDS datasets"
HOMEPAGE="https://github.com/INCF/pybids"
SRC_URI=""
EGIT_REPO_URI="https://github.com/INCF/pybids"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	"
RDEPEND="
	dev-python/grabbit[${PYTHON_USEDEP}]
	dev-python/num2words[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	"

python_test() {
	py.test -v || die
}
