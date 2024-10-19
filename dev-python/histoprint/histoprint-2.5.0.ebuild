EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Pretty print histograms to the console"
HOMEPAGE="https://github.com/scikit-hep/histoprint"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/click-7.0.0[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/uhi-0.2.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/awkward-1[${PYTHON_USEDEP}]
		>=sci-physics/uproot-4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
