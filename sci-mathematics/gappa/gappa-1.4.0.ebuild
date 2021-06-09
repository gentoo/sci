# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"
DOCS_DIR="doc/doxygen"

inherit docs multiprocessing

DESCRIPTION="Verifying and proving properties on floating-point or fixed-point arithmetic"
HOMEPAGE="https://gappa.gitlabpages.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/38436/${P}.tar.gz"

LICENSE="|| ( CeCILL-2 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	dev-libs/boost
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i Remakefile.in \
		-e "s:mkdir -p @bindir@:mkdir -p \${DESTDIR}@bindir@:g" \
		-e "s:cp src/gappa @bindir@:cp src/gappa \${DESTDIR}@bindir@:g" || die
}

src_compile() {
	# Only accept number of parrellel jobs because remake does not understand --load-average
	./remake -d -j$(makeopts_jobs) || die "emake failed"
	docs_compile
}

src_install() {
	DESTDIR="${D}" ./remake install
	einstalldocs
}
