EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

CMAKE_MAKEFILE_GENERATOR="emake"
DISTUTILS_USE_PEP517=scikit-build-core
PYPI_NO_NORMALIZE=1

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
	>=dev-python/scikit-build-core-0.2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
