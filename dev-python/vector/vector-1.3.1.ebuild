EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 pypi

DESCRIPTION="Vector classes and utilities"
HOMEPAGE="https://github.com/scikit-hep/vector"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.13.3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
