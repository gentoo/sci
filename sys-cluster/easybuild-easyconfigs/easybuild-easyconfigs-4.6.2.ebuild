EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

SUB_P=$(ver_cut 1)
SUB_PP=$(ver_cut 2)

DESCRIPTION="Provides a collection of well-tested easyconfig files for EasyBuild."
HOMEPAGE="
	https://easybuild.io/
	https://github.com/easybuilders/easybuild-easyconfigs
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sys-cluster/easybuild-framework-${SUB_P}[${PYTHON_USEDEP}]
	>=sys-cluster/easybuild-easyblocks-${SUB_P}.${SUB_PP}[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"
