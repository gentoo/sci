EAPI=8

DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Adaptive multidimensional Monte Carlo integration."
HOMEPAGE="https://github.com/gplepage/vegas"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/numpy-1.16[${PYTHON_USEDEP}]
	>=sci-libs/gvar-13.0.2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/cython-0.17[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
