EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1

DESCRIPTION="labels for various aspects of a system architecture like CPU, etc."
HOMEPAGE="https://archspec.readthedocs.io/en/latest/index.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
	<=dev-python/six-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"
