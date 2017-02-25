# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="Why is a software verification platform"
HOMEPAGE="http://why.lri.fr/"
SRC_URI="http://why.lri.fr/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="apron coq doc examples float gappa frama-c gtk pff why3"

DEPEND=">=dev-lang/ocaml-3.12.1
		>=dev-ml/ocamlgraph-1.5
		gtk? ( >=dev-ml/lablgtk-2.14 )
		apron? ( sci-mathematics/apron )
		coq? ( sci-mathematics/coq )
		gappa? ( sci-mathematics/gappalib-coq )
		pff? ( sci-mathematics/pff )
		frama-c? ( >=sci-mathematics/frama-c-20140301 )
		float? ( sci-mathematics/flocq )
		why3? ( sci-mathematics/why3 )"
RDEPEND="${DEPEND}"

DOCS=( CHANGES README Version )

src_prepare() {
	sed -i Makefile.in \
		-e "s/DESTDIR =.*//g" \
		-e "s/@COQLIB@/\$(DESTDIR)\/@COQLIB@/g" || die

	#to build with apron-0.9.10
	sed -i configure.in \
		-e "s/pvs/sri-pvs/g" \
		-e "s/oct_caml/octMPQ_caml/g" \
		-e "s/box_caml/boxMPQ_caml/g" \
		-e "s/polka_caml/polkaMPQ_caml/g" || die

	epatch "${FILESDIR}"/why-flocq23.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable apron) PATH="/usr/bin:$PATH"
}

src_compile(){
	MAKEOPTS+=" -j1"
	emake DESTDIR="/"
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
