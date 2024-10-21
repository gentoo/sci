EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
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
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.5[${PYTHON_USEDEP}]
	' python3_{11..12})

"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/pandas[${PYTHON_USEDEP}]
		>=dev-python/pytest-6.0.0[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest

src_prepare() {
	default

	sed -i -e 's:--benchmark-disable::' pyproject.toml || die
}

python_test() {
	epytest --ignore tests/particle/test_performance.py
}
