# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 git-r3 virtualx

DESCRIPTION="Time-series analysis of neuroscience data"
HOMEPAGE="http://nipy.org/nitime/index.html"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nipy/nitime"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

# import file mismatch:
RESTRICT="test"

COMMON_DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	"
BDEPEND="${COMMON_DEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	"
RDEPEND="
	${COMMON_DEPEND}
	dev-python/networkx[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	"

distutils_enable_tests pytest
distutils_enable_sphinx doc

python_test() {
	virtx pytest -v || die
}
