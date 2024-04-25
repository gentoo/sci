EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 pypi optfeature

DESCRIPTION="Vector classes and utilities"
HOMEPAGE="
	https://github.com/scikit-hep/vector
	https://vector.readthedocs.io/
	https://doi.org/10.5281/zenodo.7054478
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
# tests need numba
RESTRICT="test"

RDEPEND="
	>=dev-python/numpy-1.13.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-19[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

pkg_postinst() {
	optfeature "awkward array support" dev-python/awkward
	optfeature "sympy support" dev-python/sympy
}
