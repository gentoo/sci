# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

ID=28594

DESCRIPTION="Verifying and proving properties on floating-point or fixed-point arithmetic"
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/${ID}/${P}.tar.gz"

LICENSE="|| ( CeCILL-2.0 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

RDEPEND="
	dev-libs/boost
	dev-libs/gmp
	dev-libs/mpfr"
DEPEND="${RDEPEND}
	doc? (
		app-text/texlive
		app-text/ghostscript-gpl
		app-doc/doxygen )"

src_prepare() {
	if use doc; then
		sed \
			-i doc/doxygen/Doxyfile \
			-e "s/GENERATE_LATEX         = NO/GENERATE_LATEX         = YES/g" \
			-e "s/USE_PDFLATEX           = NO/USE_PDFLATEX           = YES/g" \
			-e "s/PDF_HYPERLINKS         = NO/PDF_HYPERLINKS         = YES/g" || die
	fi
}

src_compile(){
	emake DESTDIR="/"

	if use doc; then
		cd doc/doxygen
		doxygen Doxyfile || die "doxygen failed"
		cd "${S}"
		emake -C doc/doxygen/latex
	fi
}

src_install(){
	default

	if use doc; then
		mv doc/doxygen/latex/refman.pdf ./gappa.pdf
		dodoc ./gappa.pdf
	fi
}
