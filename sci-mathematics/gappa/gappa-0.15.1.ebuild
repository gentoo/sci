# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="A tool to help verifying and proving properties on floating-point or fixed-point arithmetic."
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/29004/${P}.tar.gz"

LICENSE="|| ( CeCILL-2.0 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

RDEPEND="dev-libs/gmp
	dev-libs/mpfr
	dev-libs/boost"
DEPEND="${RDEPEND}
		doc? ( app-text/texlive
				app-text/ghostscript-gpl
				app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	mv ${S/%0.14.0/0.13.0} ${S}
	cd ${S}
}

src_prepare() {
	sed -i doc/doxygen/Doxyfile \
		-e "s/GENERATE_LATEX         = NO/GENERATE_LATEX         = YES/g" \
		-e "s/USE_PDFLATEX           = NO/USE_PDFLATEX           = YES/g" \
		-e "s/PDF_HYPERLINKS         = NO/PDF_HYPERLINKS         = YES/g"
}

src_compile(){
	emake DESTDIR="/" || die "emake failed"

	if use doc; then
		cd doc/doxygen
		doxygen Doxyfile || die "doxygen failed"
		cd "${S}"
		emake -C doc/doxygen/latex || die "emake doc failed"
	fi
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS NEWS README

	if use doc; then
		mv doc/doxygen/latex/refman.pdf ./gappa.pdf
		dodoc ./gappa.pdf
	fi
}
