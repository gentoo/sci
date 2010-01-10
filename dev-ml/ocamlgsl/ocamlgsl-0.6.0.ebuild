# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base findlib

DESCRIPTION="OCaml bindings for the GSL library"
HOMEPAGE="http://oandrieu.nerim.net/ocaml/gsl/"
SRC_URI="http://oandrieu.nerim.net/ocaml/gsl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=dev-lang/ocaml-3.10
	>=sci-libs/gsl-1.9"
RDEPEND=${DEPEND}

PATCHES=( "${FILESDIR}/ocaml-3.11.patch" )

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	findlib_src_preinst
	emake install-findlib || die "make install failed"

	dodoc README NEWS NOTES || die "docs install failed"
	doinfo *.info* || die "info install failed"
	if use doc; then
		dohtml doc/* || die "html docs install failed"
	fi
}
