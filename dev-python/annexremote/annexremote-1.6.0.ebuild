# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PN="AnnexRemote"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Helper module to easily develop git-annex remotes"
HOMEPAGE="https://github.com/Lykos153/AnnexRemote"
SRC_URI="https://github.com/Lykos153/AnnexRemote/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

S="${WORKDIR}/${MY_P}"

COMMON_DEPEND="dev-python/future[${PYTHON_USEDEP}]"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"

distutils_enable_tests nose

python_install_all() {
	distutils-r1_python_install_all
	dodoc README.md
	use examples && dodoc -r examples
}
