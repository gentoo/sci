EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

SUB_P=$(ver_cut 1)
SUB_PP=$(ver_cut 2)

DESCRIPTION="Provides a collection of well-tested easyconfig files for EasyBuild."
HOMEPAGE="
	https://easybuild.io/
	https://github.com/easybuilders/easybuild-easyconfigs
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sys-cluster/easybuild-framework-${SUB_P}[${PYTHON_USEDEP}]
	>=sys-cluster/easybuild-easyblocks-${SUB_P}.${SUB_PP}[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
