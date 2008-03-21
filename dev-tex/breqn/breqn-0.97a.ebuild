# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="LaTeX package for line breaking of equations."
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/mh/"
SRC_URI="http://www.ctan.org/get/macros/latex/contrib/mh/breqn.dtx
	http://www.ctan.org/get/macros/latex/contrib/mh/flexisym.dtx
	http://www.ctan.org/get/macros/latex/contrib/mh/mathstyle.dtx
	http://www.ctan.org/get/macros/latex/contrib/mh/breqn-technotes.tex"
LICENSE="LPPL-1.3"
SLOT="0"
IUSE="doc"
KEYWORDS="~x86"

src_unpack() {
	mkdir "${S}"
	cd "${DISTDIR}"
	cp breqn.dtx flexisym.dtx mathstyle.dtx breqn-technotes.tex "${S}"
}

src_compile() {
	# Unpacking *.dtx
	for i in *.dtx; do
		tex $i
	done

	if use doc; then
		# To avoid sandbox violations
		export VARTEXFONTS="${T}/fonts"

		for i in mathstyle flexisym breqn; do
			pdflatex $i.drv
			makeindex -s gind.ist $i.idx
			pdflatex $i.drv
			makeindex -s gind.ist $i.idx
			pdflatex $i.drv
		done

		pdflatex breqn-technotes
		pdflatex breqn-technotes
	fi
}

src_install() {
	insinto "${TEXMF}"/tex/latex/mh
	doins *.sty *.sym

	if use doc; then
		insinto /usr/share/doc/${P}
		doins *.pdf
	fi
}
