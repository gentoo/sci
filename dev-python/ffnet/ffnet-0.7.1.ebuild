# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Feed-forward neural network for python"
HOMEPAGE="http://ffnet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
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
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
