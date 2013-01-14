# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools

DESCRIPTION="A graph library for Objective Caml"
HOMEPAGE="http://ocamlgraph.lri.fr/"
SRC_URI="http://ocamlgraph.lri.fr/download/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc examples gtk +ocamlopt"

DEPEND=">=dev-lang/ocaml-3.10.2[ocamlopt?]
		gtk? ( >=dev-ml/lablgtk-2.12[gnomecanvas,ocamlopt?] )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-makefile.patch"
	eautoreconf
}

src_compile() {
	emake -j1 DESTDIR="/" || die "emake failed"

	if use doc; then
		emake doc || die "emake doc failed"
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc CHANGES CREDITS FAQ README

	if use doc; then
		dohtml doc/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
