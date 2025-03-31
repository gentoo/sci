EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 # pypi does not include tests

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

DESCRIPTION="Histograms with task scheduling."
HOMEPAGE="
	https://github.com/dask-contrib/dask-histogram
	https://dask-histogram.readthedocs.io/
"
SRC_URI="
	https://github.com/dask-contrib/dask-histogram/archive/refs/tags/${PV}.tar.gz -> {P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/boost-histogram-1.3.2[${PYTHON_USEDEP}]
	>=dev-python/dask-2021.03.0[${PYTHON_USEDEP}]
	>=dev-python/dask-awkward-2025[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/hist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
