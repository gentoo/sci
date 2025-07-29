EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=hatchling
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
inherit distutils-r1 pypi

DESCRIPTION="Universal Histogram Interface"
HOMEPAGE="https://github.com/scikit-hep/uhi"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.13.3[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/boost-histogram[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	${RDEPEND}
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
