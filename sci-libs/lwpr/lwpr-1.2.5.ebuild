# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"

inherit docs

DESCRIPTION="The Locally Weighted Projection Regression Library"
HOMEPAGE="https://web.inf.ed.ac.uk/slmc"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples octave static-libs"

RDEPEND="octave? ( >=sci-mathematics/octave-3 )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--enable-threads=3 \
		$(use_with octave octave)
}

src_compile() {
	default
	docs_compile
}

src_install() {
	default
	if use doc; then
	dodoc doc/lwpr_doc.pdf
	dodoc html/*
	fi
	if use examples ; then
		docinto /usr/share/doc/${PF}/examples
		dodoc example_c/cross.c example_cpp/cross.cc
	fi
	if use octave; then
		insinto /usr/share/octave/packages/${P}
		doins matlab/*.m
	fi
}
