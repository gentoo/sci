EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A Pythonic wrapper for the HepMC3 C++ library."
HOMEPAGE="https://github.com/scikit-hep/pyhepmc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.0[${PYTHON_USEDEP}]
"
BDEPEND="
        ${RDEPEND}
        dev-build/cmake
"
