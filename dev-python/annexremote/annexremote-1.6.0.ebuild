# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="Helper module to easily develop git-annex remotes"
HOMEPAGE="https://github.com/Lykos153/AnnexRemote"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
# Tests require nose, reported upstream:
# https://github.com/Lykos153/AnnexRemote/issues/61
RESTRICT="test"

python_install_all() {
	distutils-r1_python_install_all
	dodoc README.md
	use examples && dodoc -r examples
}
