# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
PYTHON_COMPAT=( python3_3 )

inherit distutils-r1

MY_P="${P/mdp/MDP}"
MY_P="${MY_P/_rc/RC}"

DESCRIPTION="Data processing framework in python"
HOMEPAGE="http://mdp-toolkit.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/mdp-toolkit/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| (
			>=dev-python/numpy-1.1[${PYTHON_USEDEP}]
			>=sci-libs/scipy-0.5.2[${PYTHON_USEDEP}]
			)"

S="${WORKDIR}/${MY_P}"

python_test() {
	distutils_install_for_testing
	cd "${BUILD_DIR}" || die
	"${PYTHON}" -c "import mdp;mdp.test()" || die
}
