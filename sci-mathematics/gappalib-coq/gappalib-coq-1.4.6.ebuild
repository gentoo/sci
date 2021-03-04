# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Allows the certificates Gappa generates to be imported by the Coq"
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/38386/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=sci-mathematics/gappa-1.3.2
	>=sci-mathematics/coq-8.8
	>=sci-mathematics/flocq-3.0
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i Remakefile.in \
		-e "s:mkdir -p @libdir@:mkdir -p \${DESTDIR}@libdir@:g" \
		-e "s:cp \$(OBJS) \$(MLTARGETS) @libdir@:cp \$(OBJS) \$(MLTARGETS) \${DESTDIR}@libdir@:g"
}

src_compile() {
	./remake || die "emake failed"
}

src_install() {
	DESTDIR="${D}" ./remake install || die "emake install failed"
	einstalldocs
}
