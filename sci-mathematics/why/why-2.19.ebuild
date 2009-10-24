# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

DESCRIPTION="Why is a software verification platform."
HOMEPAGE="http://why.lri.fr/"
SRC_URI="http://why.lri.fr/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="apron coq doc examples gappa gtk pff pvs"

DEPEND=">=dev-lang/ocaml-3.09
		>=dev-ml/ocamlgraph-1.2
		gtk? ( >=dev-ml/lablgtk-2.12 )
		apron? ( sci-mathematics/apron )
		coq? ( sci-mathematics/coq )
		gappa? ( sci-mathematics/gappalib-coq )
		pff? ( sci-mathematics/pff )
		pvs? ( sci-mathematics/pvs )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile_sandbox.patch"

	mv jc/jc_ast.mli jc/jc_ast.ml
	mv jc/jc_env.mli jc/jc_env.ml
	epatch "${FILESDIR}/${P}-jessie_lib.patch"

	#to build with apron-0.9.10
	sed -i configure.in \
		-e "s/pvs/sri-pvs/g" \
		-e "s/oct_caml/octMPQ_caml/g" \
		-e "s/box_caml/boxMPQ_caml/g" \
		-e "s/polka_caml/polkaMPQ_caml/g"

	eautoreconf
}

src_configure() {
	econf $(use_enable apron) PATH="/usr/bin:$PATH" || die "econf failed"
}

src_compile(){
	emake DESTDIR="/" || die "emake failed"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc CHANGES COPYING README Version
	doman doc/why.1

	if use doc; then
		dodoc doc/manual.ps
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples examples-c
	fi
}

