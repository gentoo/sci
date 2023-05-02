# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
inherit distutils-r1

DESCRIPTION="Helper module to easily develop git-annex remotes"
HOMEPAGE="https://github.com/Lykos153/AnnexRemote"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
# Reported upstream:
# https://github.com/Lykos153/AnnexRemote/issues/61
RESTRICT="test"

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
