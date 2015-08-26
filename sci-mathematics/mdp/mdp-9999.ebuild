# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1 git-r3

MY_P="${P/mdp/MDP}"
MY_P="${MY_P/_rc/RC}"

DESCRIPTION="Modular data processing framework for python"
HOMEPAGE="http://mdp-toolkit.sourceforge.net/index.html"
SRC_URI=""
EGIT_REPO_URI="git://github.com/mdp-toolkit/mdp-toolkit.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="|| (
			>=dev-python/numpy-1.1[${PYTHON_USEDEP}]
			>=sci-libs/scipy-0.5.2[${PYTHON_USEDEP}]
			)"

python_test() {
	distutils_install_for_testing
	cd "${BUILD_DIR}" || die
	"${PYTHON}" -c "import mdp;mdp.test()" || die
}
