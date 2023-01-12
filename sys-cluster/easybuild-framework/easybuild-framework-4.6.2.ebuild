EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="The easybuild-framework package is the core of EasyBuild."
HOMEPAGE="
	https://easybuild.io/
	https://github.com/easybuilders/easybuild-framework
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
dev-python/flake8[${PYTHON_USEDEP}]
dev-python/keyring[${PYTHON_USEDEP}]
dev-python/GitPython[${PYTHON_USEDEP}]
dev-python/pyyaml[${PYTHON_USEDEP}]
dev-python/autopep8[${PYTHON_USEDEP}]
dev-python/requests[${PYTHON_USEDEP}]
dev-python/cryptography[${PYTHON_USEDEP}]
dev-python/rich[${PYTHON_USEDEP}]
dev-python/archspec[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
)
