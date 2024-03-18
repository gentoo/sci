EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="EasyBuild is a software build and installation framework."
HOMEPAGE="
	https://easybuild.io/
	https://github.com/easybuilders/easybuild
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

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
}
