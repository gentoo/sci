EAPI=8

PYTHON_COMPAT=( python3_11 )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1

DESCRIPTION="PDG particle data and identification codes"
HOMEPAGE="https://github.com/scikit-hep/particle"

LICENSE="BSD"
SLOT="0"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scikit-hep/particle"
else
	inherit pypi
	KEYWORDS="~amd64"
fi

RDEPEND="
	>=dev-python/attrs-19.2[${PYTHON_USEDEP}]
	>=sci-physics/hepunits-2.0.0[${PYTHON_USEDEP}]
	dev-python/deprecated[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-6.0.0[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
	)
"
BDEPEND="${RDEPEND}"
distutils_enable_tests pytest

src_prepare() {
	default

	sed -i -e 's:--benchmark-disable::' pyproject.toml || die
}

python_test() {
	epytest --ignore tests/particle/test_performance.py
}
