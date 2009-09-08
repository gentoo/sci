# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit eutils

DESCRIPTION="A graph library for Objective Caml"
HOMEPAGE="http://ocamlgraph.lri.fr/"
SRC_URI="http://ocamlgraph.lri.fr/download/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND=">=dev-lang/ocaml-3.10.2"

DEPEND="${RDEPEND}
    gtk? ( >=dev-ml/lablgtk-2.6 )
    ocamlopt? ( dev-lang/ocaml[ocamlopt] )"

IUSE="doc examples gtk +ocamlopt"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	econf || die "econf failed"
	emake DESTDIR="/" || die "emake failed"

	if use doc; then
		emake doc || die "emake doc failed"
	fi
}

src_install() {
	emake install-bin install-findlib DESTDIR="${D}" || die "emake install failed"
	dodoc CHANGES COPYING CREDITS FAQ README

	if use doc; then
		dohtml doc/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

