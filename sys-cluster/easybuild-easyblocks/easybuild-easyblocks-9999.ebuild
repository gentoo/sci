EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

SUB_P=$(ver_cut 1)

DESCRIPTION="Provides a collection of easyblocks for EasyBuild."
HOMEPAGE="
	https://easybuild.io/
	https://github.com/easybuilders/easybuild-easyblocks
"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/easybuilders/easybuild-easyblocks"
	SUB_P=9999
else
	inherit pypi
	KEYWORDS="~amd64"
fi

RDEPEND="
	>=sys-cluster/easybuild-framework-${SUB_P}[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	# already there from easybuild_framework
	rm easybuild/__init__.py || die
	default
}
