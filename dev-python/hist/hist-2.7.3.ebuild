EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=hatchling
SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
inherit distutils-r1 pypi

DESCRIPTION="Histogramming for analysis powered by boost-histogram "
HOMEPAGE="https://github.com/scikit-hep/hist"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/boost-histogram-1.3.1[${PYTHON_USEDEP}]
	>=dev-python/histoprint-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.14.5[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

RESTRICT="test"
# needs mplhep and dask_histogram ...
#distutils_enable_tests pytest
