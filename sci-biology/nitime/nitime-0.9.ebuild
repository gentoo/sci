# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )

inherit distutils-r1 virtualx

DESCRIPTION="Time-series analysis of neuroscience data"
HOMEPAGE="http://nipy.org/nitime/index.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
