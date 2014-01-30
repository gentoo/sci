# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-pypy-*"
PYTHON_COMPAT=( python2_5 python2_6 python2_7 )

inherit distutils-r1 flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Feed-forward neural network for python"
HOMEPAGE="http://ffnet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE="examples graphviz matplotlib"

DEPEND="${PYTHON_DEPS}
	dev-python/networkx
	dev-python/numpy
	sci-libs/scipy
	matplotlib? ( dev-python/matplotlib )
	graphviz? ( dev-python/pygraphviz )"
RDEPEND="${DEPEND}"

src_prepare() {
	export FCONFIG="config_fc --noopt --noarch"
	append-ldflags -shared
	append-fflags -fPIC
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile ${FCONFIG}
}

src_install() {
	distutils-r1_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
