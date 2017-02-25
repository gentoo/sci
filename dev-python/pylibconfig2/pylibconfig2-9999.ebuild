# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python{3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Pure python library for libconfig syntax"
HOMEPAGE="https://github.com/heinzK1X/pylibconfig2"
EGIT_REPO_URI="https://github.com/heinzK1X/${PN}.git git://github.com/heinzK1X/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

python_test() {
	distutils_install_for_testing
	esetup.py test || die
}
