# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 fortran-2 flag-o-matic

DESCRIPTION="Feed-forward neural network for python"
HOMEPAGE="http://ffnet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="examples graphviz matplotlib"

DEPEND="${PYTHON_DEPS}
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	graphviz? ( dev-python/pygraphviz[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

python_prepare_all() {
	export FCONFIG="config_fc --noopt --noarch"
	append-ldflags -shared
	append-fflags -fPIC
	distutils-r1_python_prepare_all
}

src_compile() {
	distutils-r1_src_compile ${FCONFIG}
}

python_install_all() {
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
