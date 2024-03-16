EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=hatchling
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
inherit distutils-r1 pypi

DESCRIPTION="Manipulate JSON-like data with NumPy-like idioms."
HOMEPAGE="https://github.com/scikit-hep/awkward"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	~dev-python/awkward-cpp-28[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	test? (
		dev-python/pyarrow[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/numexpr[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	tests-cuda/
	tests-cuda-kernels/
)

distutils_enable_tests pytest
