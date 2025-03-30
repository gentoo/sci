EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

CMAKE_MAKEFILE_GENERATOR="emake"
DISTUTILS_USE_PEP517=scikit-build-core
DISTUTILS_EXT=1

inherit pypi distutils-r1

DESCRIPTION="awkward-cpp bindings for Python"
HOMEPAGE="https://github.com/scikit-hep/awkward/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-python/scikit-build-core-0.10[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	# https://github.com/scikit-build/scikit-build-core/issues/912
	sed -i -e '/scikit-build-core/s:0\.10:0.8:' pyproject.toml || die
}

distutils_enable_tests pytest
