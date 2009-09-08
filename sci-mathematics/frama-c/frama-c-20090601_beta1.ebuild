# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit autotools eutils

DESCRIPTION="Frama-C is a suite of tools dedicated to the analysis of the source code of software written in C."
HOMEPAGE="http://www.frama-c.cea.fr/"
NAME="Beryllium"
SRC_URI="http://www.frama-c.cea.fr/download/${PN/-c/-c-$NAME}-${PV/_/-}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE="apron coq doc gappa gtk pff pvs +why"
RESTRICT="strip"

RDEPEND="sci-mathematics/ltl2ba
		apron? ( sci-mathematics/apron )
        coq? ( sci-mathematics/coq )
        gappa? ( sci-mathematics/gappalib-coq )
        pff? ( sci-mathematics/pff )
        pvs? ( sci-mathematics/pvs )
		why? ( sci-mathematics/why )"

DEPEND="${RDEPEND}
		>=dev-lang/ocaml-3.10.2
		>=dev-ml/ocamlgraph-1.1
		gtk? ( >=dev-ml/lablgtk-2.12 )"

S="${WORKDIR}/${PN/-c/-c-$NAME}-${PV/_/-}"

src_unpack(){
	unpack ${A}
	cd "${S}"

	mv src/value/state_set.ml* src/memory_state/ || die
	epatch "${FILESDIR}/${P}-states_hook.patch"
	epatch "${FILESDIR}/${P}-stmt_deps.patch"
	epatch "${FILESDIR}/${P}-accessors.patch"
	epatch "${FILESDIR}/${P}-printexc.patch"
	epatch "${FILESDIR}/${P}-configure.patch"
	epatch "${FILESDIR}/${P}-ocamlgraph.patch"
	epatch "${FILESDIR}/${P}-install_files.patch"

	eautoreconf
}

src_compile() {
	if use gtk; then
		myconf="--enable-gui"
	else
		myconf="--disable-gui"
	fi

	econf ${myconf} --with-whydir=no || die "econf failed"

	# dependencies can not be processed in parallel,
	# this is the intended behavior.
	emake -j1 depend || die "emake depend failed"
	emake DESTDIR="/" || die "emake failed"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc Changelog doc/README

	if use doc; then
		dodoc doc/manuals/* 
	fi
}

