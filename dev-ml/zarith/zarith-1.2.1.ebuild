# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils findlib multilib

DESCRIPTION="The Zarith library implements arithmetic and logical operations over arbitrary-precision integers"
HOMEPAGE="http://forge.ocamlcore.org/projects/zarith"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1199/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt doc mpir"

DEPEND="
	>=dev-lang/ocaml-3.12.1[ocamlopt?]
	!mpir? ( dev-libs/gmp:0 )
	mpir? ( sci-libs/mpir:0 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	OCAMLDIR=$(ocamlc -where)
}

src_prepare(){
	sed \
		-e 's:(OCAMLFIND) install:(OCAMLFIND) install -ldconf $(INSTALLDIR)/ld.conf:g' \
		-i "${S}"/project.mak || die
}

src_configure(){
	MY_OPTS="-ocamllibdir /usr/$(get_libdir) -installdir ${D}/${OCAMLDIR}"
	use mpir && MY_OPTS="${MY_OPTS} -mpir"
	./configure ${MY_OPTS} || die "configure failed"
}

src_compile(){
	default
	use doc && emake doc
}

src_install(){
	findlib_src_preinst
	cp "${OCAMLDIR}"/ld.conf "${D}/${OCAMLDIR}"/ld.conf || die
	default
	rm -f "${D}/${OCAMLDIR}"/ld.conf || die
	DOCS=( Changes README )
	use doc && HTML_DOCS=( html/. )
	einstalldocs
}
