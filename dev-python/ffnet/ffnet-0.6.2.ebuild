# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils flag-o-matic toolchain-funcs

DESCRIPTION="Feed-forward neural network for python"
HOMEPAGE="http://ffnet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"
IUSE="examples graphviz matplotlib"

DEPEND="
	dev-python/networkx
	dev-python/numpy
	sci-libs/scipy
	matplotlib? ( dev-python/matplotlib )
	graphviz? ( dev-python/pygraphviz )"
RDEPEND="${DEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

pkg_setup() {
	[[ -z ${FC}  ]] && export FC=$(tc-getFC)
	# hack to force F77 to be FC until bug #278772 is fixed
	[[ -z ${F77} ]] && export F77=$(tc-getFC)
	export FCONFIG="config_fc --noopt --noarch"
}

src_compile() {
	append-ldflags -shared
	[[ -n ${FFLAGS} ]] && FFLAGS="${FFLAGS} -fPIC"
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
