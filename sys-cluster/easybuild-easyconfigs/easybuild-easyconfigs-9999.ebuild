EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1

SUB_P=$(ver_cut 1)
SUB_PP=${SUB_P}.$(ver_cut 2)

DESCRIPTION="Provides a collection of well-tested easyconfig files for EasyBuild."
HOMEPAGE="
	https://easybuild.io/
	https://github.com/easybuilders/easybuild-easyconfigs
"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/easybuilders/easybuild-easyconfigs"
	SUB_P=9999
	SUB_PP=9999
else
	inherit pypi
	KEYWORDS="~amd64"
fi

RDEPEND="
	>=sys-cluster/easybuild-framework-${SUB_P}[${PYTHON_USEDEP}]
	>=sys-cluster/easybuild-easyblocks-${SUB_PP}[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"
