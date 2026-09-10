EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 flag-o-matic

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scikit-hep/pyhepmc.git"
else
	inherit pypi
	KEYWORDS="~amd64"
fi

DESCRIPTION="A Pythonic wrapper for the HepMC3 C++ library"
HOMEPAGE="https://github.com/scikit-hep/pyhepmc"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=dev-python/numpy-1.2[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	dev-build/cmake
"

src_compile() {
	filter-lto
	append-cxxflags -fno-strict-aliasing
	distutils-r1_src_compile
}
