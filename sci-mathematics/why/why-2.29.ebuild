# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils

DESCRIPTION="Software verification platform"
HOMEPAGE="http://why.lri.fr/"
SRC_URI="http://why.lri.fr/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="apron coq doc examples gappa gtk jessie pff"

DEPEND="
	>=dev-lang/ocaml-3.09
	>=dev-ml/ocamlgraph-1.2
	apron? ( sci-mathematics/apron )
	coq? ( sci-mathematics/coq )
	gappa? ( sci-mathematics/gappalib-coq )
	gtk? ( >=dev-ml/lablgtk-2.14 )
	jessie? ( >=sci-mathematics/frama-c-20100401 )
	pff? ( sci-mathematics/pff )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e "s/DESTDIR =.*//g" \
		-e "s/@COQLIB@/\$(DESTDIR)\/@COQLIB@/g" \
		-i Makefile.in || die

	#to build with apron-0.9.10
	sed \
		-e "s/pvs/sri-pvs/g" \
		-e "s/oct_caml/octMPQ_caml/g" \
		-e "s/box_caml/boxMPQ_caml/g" \
		-e "s/polka_caml/polkaMPQ_caml/g" \
		-i configure.in || die

	epatch "${FILESDIR}"/${PN}_jessie-carbon.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable apron)
}

src_compile(){
	emake -j1 DESTDIR="${EROOT}" || die "emake failed"
}

src_install(){
	default

	doman doc/why.1

	if use doc; then
		dodoc doc/manual.ps
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples examples-c
	fi
}
