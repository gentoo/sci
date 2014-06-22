# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="The Zarith library implements arithmetic and logical operations over arbitrary-precision integers"
HOMEPAGE="http://forge.ocamlcore.org/projects/zarith"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1199/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

OCAMLDIR=`ocamlc -where`

DEPEND=">=dev-lang/ocaml-3.12.1[ocamlopt?]
		dev-libs/gmp"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -i ${S}/project.mak -e "s:(OCAMLFIND) install:(OCAMLFIND) install -ldconf \$(INSTALLDIR)/ld.conf:g"
}

src_configure(){
    ./configure -installdir "${D}${OCAMLDIR}" || die "configure failed"
}

src_compile(){
	emake || die "emake failed"
}

src_install(){
	mkdir -p "${D}${OCAMLDIR}"
	cp "${OCAMLDIR}/ld.conf" "${D}${OCAMLDIR}/ld.conf"
	emake install || die "emake install failed"
	rm "${D}${OCAMLDIR}/ld.conf"
	dodoc Changes README
}
