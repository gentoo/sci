EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Numerical derivatives for analytic functions with arbitrary precision."
HOMEPAGE="https://github.com/HDembinski/jacobi"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.10[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		tests/bench.py
	)
	epytest
}
