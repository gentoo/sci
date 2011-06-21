# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils fortran-2 flag-o-matic toolchain-funcs

DESCRIPTION="Feed-forward neural network for python"
HOMEPAGE="http://ffnet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE="examples graphviz matplotlib"

DEPEND="
	dev-python/networkx
	dev-python/numpy
	sci-libs/scipy
	matplotlib? ( dev-python/matplotlib )
	graphviz? ( dev-python/pygraphviz )"
RDEPEND="${DEPEND}"

pkg_setup() {
	fortran-2_pkg_setup
	export FCONFIG="config_fc --noopt --noarch"
	append-ldflags -shared
	append-fflags -fPIC
}

src_compile() {
	distutils_src_compile ${FCONFIG}
}

src_install() {
	distutils_src_install
	dodoc README || die
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}
