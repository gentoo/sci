# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Allows the certificates Gappa generates to be imported by the Coq"
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/32743/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gappa
		sci-mathematics/coq
		sci-mathematics/flocq"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i Remakefile.in \
		-e "s:mkdir -p @libdir@:mkdir -p \${DESTDIR}@libdir@:g" \
		-e "s:cp \$(OBJS) \$(MLTARGETS) @libdir@:cp \$(OBJS) \$(MLTARGETS) \${DESTDIR}@libdir@:g"
}

src_compile() {
	./remake || die "emake failed"
}

src_install() {
	DESTDIR="${D}" ./remake install || die "emake install failed"
	dodoc NEWS README AUTHORS ChangeLog
}
