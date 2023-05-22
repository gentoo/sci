EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

SUB_P=$(ver_cut 1)

DESCRIPTION="Provides a collection of easyblocks for EasyBuild."
HOMEPAGE="
	https://easybuild.io/
	https://github.com/easybuilders/easybuild-easyblocks
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sys-cluster/easybuild-framework-${SUB_P}[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

src_prepare() {
	# already there from easybuild_framework
	rm easybuild/__init__.py || die
	default
}
