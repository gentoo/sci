EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A package to provide example files for testing and developing packages against."
HOMEPAGE="https://github.com/scikit-hep/scikit-hep-testdata"
# pypi does not include the data nor tests
SRC_URI="https://github.com/scikit-hep/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${P}"
# export is needed here!
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
# otherwise we don't install the data
export SKHEP_DATA=1

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
