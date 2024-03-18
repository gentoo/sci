EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature

DESCRIPTION="EasyBuild is a software build and installation framework."
HOMEPAGE="
	https://easybuild.io/
	https://github.com/easybuilders/easybuild
"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/easybuilders/easybuild"
else
	inherit pypi
	KEYWORDS="~amd64"
fi

RDEPEND="
	dev-libs/openssl
	dev-tcltk/tclx
	|| ( >=sys-cluster/lmod-6.5.1 >=sys-cluster/modules-4.6.0-r1 )
	~sys-cluster/easybuild-framework-${PV}[${PYTHON_USEDEP}]
	~sys-cluster/easybuild-easyblocks-${PV}[${PYTHON_USEDEP}]
	~sys-cluster/easybuild-easyconfigs-${PV}[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

pkg_postinst() {
	elog "Remember to set the module install path"
	elog "ml use \$installpath/modules/all"
	elog "where --installpath is passed to eb"

	optfeature "GitHub PR integration" dev-python/keyring dev-python/GitPython
}
