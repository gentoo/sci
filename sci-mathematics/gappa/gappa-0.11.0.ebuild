# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

DESCRIPTION="A tool to help verifying and proving properties on floating-point or fixed-point arithmetic."
HOMEPAGE="http://lipforge.ens-lyon.fr/www/gappa/"
SRC_URI="http://lipforge.ens-lyon.fr/frs/download.php/150/${P}.tar.gz"

LICENSE="CeCILL GPL-2"
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
	cd ${S}
	
	sed -i doc/doxygen/Doxyfile \
		-e "s/GENERATE_LATEX         = NO/GENERATE_LATEX         = YES/g" \
		-e "s/USE_PDFLATEX           = NO/USE_PDFLATEX           = YES/g" \
		-e "s/PDF_HYPERLINKS         = NO/PDF_HYPERLINKS         = YES/g"
}

src_compile(){
	econf || die "econf failed"
	emake DESTDIR="/" || die "emake failed"

	if use doc; then
		cd doc/doxygen
		doxygen Doxyfile || die "doxygen failed"
		cd ${S}
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

