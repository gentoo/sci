EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 pypi

DESCRIPTION="Histogram plots using matplotlib and HEP compatible styling ROOT."
HOMEPAGE="
	https://mplhep.readthedocs.io
	https://github.com/scikit-hep/mplhep
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/matplotlib-3.4[${PYTHON_USEDEP}]
	>=sci-physics/mplhep-data-0.0.4[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/uhi-0.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/boost-histogram[${PYTHON_USEDEP}]
		dev-python/hist[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-mpl[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		>=dev-python/pytest-6.0[${PYTHON_USEDEP}]
		sci-physics/scikit-hep-testdata[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.1.0[${PYTHON_USEDEP}]
		sci-physics/uproot[${PYTHON_USEDEP}]
	)
"

# we do not want to care about old uproot4
EPYTEST_DESELECT=(
	'tests/test_inputs.py::test_inputs_uproot'
	'tests/test_inputs.py::test_uproot_versions[png]'
	'tests/test_inputs.py::test_uproot_versions[pdf]'
	'tests/test_inputs.py::test_uproot_versions[svg]'
)

distutils_enable_tests pytest
