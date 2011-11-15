# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils findlib

DESCRIPTION="BLAS/LAPACK interface for OCaml"
HOMEPAGE="http://www.ocaml.info/home/ocaml_sources.html"
SRC_URI="http://hg.ocaml.info/release/${PN}/archive/release-${PV}.tar.bz2
-> ${P}.tar.bz2"

LICENSE="LGPL-2.1-linking-exception"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="dev-lang/ocaml[ocamlopt]
	virtual/blas
	virtual/lapack"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-release-${PV}"

src_prepare() {
	sed -i -e "s/blas/$(pkg-config --libs blas|sed s/-l//g)/" \
		   -e "s/lapack/$(pkg-config --libs lapack|sed s/-l//g)/" Makefile.conf ||die
}

src_compile() {
	emake
	use doc && emake doc
}

src_install() {
	findlib_src_install
	dodoc README.txt Changelog
	use doc && dodoc -r doc/lacaml/html doc/lacaml/latex
}
