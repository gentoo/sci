# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Phylogenetic Bayesian analysis program"
HOMEPAGE="http://megasun.bch.umontreal.ca/People/lartillot/www/download.html"
SRC_URI="http://megasun.bch.umontreal.ca/People/lartillot/www/phylobayes3.3b.tar.gz
	http://megasun.bch.umontreal.ca/People/lartillot/www/phylobayes3.3.pdf"

LICENSE=""
SLOT="0"
#KEYWORDS="~amd64 ~x86"
KEYWORDS=""
IUSE="gsl latex"

DEPEND="gsl? ( sci-libs/gsl )"
RDEPEND="${DEPEND}
	latex? ( dev-texlive/texlive-latex
			app-text/dvipsk )"

S="${WORKDIR}"/phylobayes3.3b

src_prepare(){
	if use gsl; then
		sed -i 's/#USE_GSL/USE_GSL/' sources/Makefile
	sed -i 's/CC/CXX/g' sources/Makefile
	fi
}

src_install(){
	dobin exe_lin64/*
	insinto /usr/share/"${P}"/aux_ps
	doins aux_ps/header.tex
	dodoc "${DISTDIR}"/phylobayes3.3.pdf
}
