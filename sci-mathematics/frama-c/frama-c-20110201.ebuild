# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools eutils

DESCRIPTION="Framework for analysis of source codes written in C"
HOMEPAGE="http://frama-c.com"
NAME="Carbon"
SRC_URI="http://frama-c.com/download/${PN/-c/-c-$NAME}-${PV/_/-}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="apron doc gtk +ocamlopt +why"
RESTRICT="strip"

DEPEND=">=dev-lang/ocaml-3.10.2[ocamlopt?]
		>=dev-ml/ocamlgraph-1.7[gtk?,ocamlopt?]
		gtk? ( >=x11-libs/gtksourceview-2.8
			>=gnome-base/libgnomecanvas-2.26
			>=dev-ml/lablgtk-2.14[sourceview,gnomecanvas,ocamlopt?] )
		sci-mathematics/ltl2ba
		apron? ( sci-mathematics/apron )"
RDEPEND="${DEPEND}"
PDEPEND="why? ( >=sci-mathematics/why-2.29 )"

S="${WORKDIR}/${PN/-c/-c-$NAME}-${PV/_/-}"

src_prepare(){
	rm share/libc/test.c
	rm -Rf src/wp

	mkdir cil/pdf
	mv cil/doc/*.pdf cil/doc/*.tex cil/pdf
	mv cil/doc cil/html
	mv doc/manuals doc/pdf

	touch config_file
	eautoreconf
}

src_configure() {
	if use gtk; then
		myconf="--enable-gui"
	else
		myconf="--disable-gui"
	fi

	econf ${myconf} || die "econf failed"
}

src_compile() {
	# dependencies can not be processed in parallel,
	# this is the intended behavior.
	emake -j1 depend || die "emake depend failed"
	emake all top DESTDIR="/" || die "emake failed"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc Changelog doc/README

	if use doc; then
		dodoc doc/pdf/*.pdf
		dodoc cil/pdf/*.pdf
		dohtml -r cil/html/*
	fi
}
