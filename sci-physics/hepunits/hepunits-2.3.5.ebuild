EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1

DESCRIPTION="units and constants in the HEP system of units"
HOMEPAGE="https://github.com/scikit-hep/hepunits"

LICENSE="BSD"
SLOT="0"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scikit-hep/hepunits"
else
	inherit pypi
	KEYWORDS="~amd64"
fi


BDEPEND="dev-python/hatch-vcs[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
