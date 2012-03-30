# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit findlib eutils

DESCRIPTION="Arithmetic and logic operations over arbitrary-precision integers"
HOMEPAGE="https://forge.ocamlcore.org/projects/zarith/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/835/${P}.tgz"

LICENSE="LGPL-2.1-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc mpir +ocamlopt"

RDEPEND=">=dev-lang/ocaml-3.12.1[ocamlopt?]
!mpir? ( dev-libs/gmp )
mpir? ( sci-libs/mpir )"

DEPEND="${RDEPEND}
dev-lang/perl"

src_configure() {
	MY_OPTS="-ocamllibdir /usr/$(get_libdir) -installdir \
	${D}/usr/$(get_libdir)/ocaml"
	use mpir && MY_OPTS="${MY_OPTS} -mpir"
	./configure ${MY_OPTS}|| die
}

src_compile() {
	emake all
	use doc && emake doc
}

src_test() {
	if use ocamlopt; then
		emake test;LD_LIBRARY_PATH="." ./test || die
	else
		emake test.b;LD_LIBRARY_PATH="." ./test.b || die
	fi
}

src_install() {
	findlib_src_preinst
	emake install
	dodoc Changes README
	use doc && dodoc -r html/
}
