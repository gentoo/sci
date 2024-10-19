EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 pypi

DESCRIPTION="DecayLanguage: describe, manipulate and convert particle decays"
HOMEPAGE="https://github.com/scikit-hep/decaylanguage"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/attrs-19.2[${PYTHON_USEDEP}]
	>=dev-python/graphviz-0.12.0[${PYTHON_USEDEP}]
	>=dev-python/lark-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.12[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.22[${PYTHON_USEDEP}]
	>=sci-physics/particle-0.21.0[${PYTHON_USEDEP}]
	>=sci-physics/hepunits-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/plumbum-1.7.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
