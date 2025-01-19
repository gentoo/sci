EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 pypi

DESCRIPTION="A Pythonic wrapper for the HepMC3 C++ library."
HOMEPAGE="https://github.com/scikit-hep/pyhepmc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.2[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	dev-build/cmake
"
