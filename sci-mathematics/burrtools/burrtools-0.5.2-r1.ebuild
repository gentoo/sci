# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Program to solve assembly and interlocking puzzles"
HOMEPAGE="http://burrtools.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/${P}-A4.pdf )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="doc examples"

DEPEND="
	x11-libs/fltk:1
	media-libs/libpng:0="
RDEPEND="${DEPEND}
	app-text/htmldoc"

src_compile() {
	default
	cd doc || die
	cp ../doc_src/*.png . || die
	echo "User Guide for BurrTools ${PV}" > doc/userGuide.t2t
	cat ../doc_src/userGuide.t2t >> userGuide.t2t
	mkdir html || die
	../doc_src/txt2tags.py -t html -o - userGuide.t2t > userGuide.html
	htmldoc --format htmlsep --toclevels 2 --outdir html userGuide.html || die
	cd .. || die
}

src_install() {
	default
	use doc && dodoc "${DISTDIR}"/${P}-A4.pdf
	if use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
