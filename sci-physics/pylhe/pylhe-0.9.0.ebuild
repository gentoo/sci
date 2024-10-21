EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 pypi

DESCRIPTION="Lightweight Python interface to read Les Houches Event (LHE) files"
HOMEPAGE="https://github.com/scikit-hep/pylhe"
# pypi does not include tests
SRC_URI="https://github.com/scikit-hep/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
# export is needed here!
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/graphviz-0.12.0[${PYTHON_USEDEP}]
	>=sci-physics/particle-0.16[${PYTHON_USEDEP}]
	>=dev-python/awkward-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/vector-0.8.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=sci-physics/scikit-hep-testdata-0.4.36[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}"-0.7.0-coverage.patch
)

distutils_enable_tests pytest
