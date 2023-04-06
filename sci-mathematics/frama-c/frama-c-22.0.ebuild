# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

NAME="Titanium"

DESCRIPTION="Framework for analysis of source codes written in C"
HOMEPAGE="https://frama-c.com"
SRC_URI="https://frama-c.com/download/${P}-${NAME}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="doc gtk +ocamlopt"
RESTRICT="strip"

DEPEND="
	>=dev-lang/ocaml-3.12.1[ocamlopt?]
	>=dev-ml/ocamlgraph-1.8.5[ocamlopt?]
	dev-ml/zarith
	dev-ml/yojson
	sci-mathematics/coq
	sci-mathematics/ltl2ba
	sci-mathematics/alt-ergo
	gtk? (
		>=x11-libs/gtksourceview-2.8:2.0
		>=gnome-base/libgnomecanvas-2.26
		>=dev-ml/lablgtk-2.14[sourceview,gnomecanvas(-),ocamlopt?]
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-${NAME}"

src_prepare(){
	touch config_file || die
	rm -f ocamlgraph.tar.gz || die
	default
	eautoreconf
}

src_configure(){
	econf "$(use_enable gtk gui )"
}

src_compile(){
	# dependencies can not be processed in parallel,
	# this is the intended behavior.
	emake depend
	emake all top DESTDIR="/"

	use doc && emake doc
}

src_install(){
	default
	use doc && dodoc -r doc/doxygen/html/*
}
