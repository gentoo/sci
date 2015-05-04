# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Program to solve assembly and interlocking puzzles"
HOMEPAGE="http://burrtools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/${P}-A4.pdf )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

IUSE="doc examples"

DEPEND="
	x11-libs/fltk:1
	media-libs/libpng"
RDEPEND="${DEPEND}
	app-text/htmldoc"

src_configure() {
	econf --docdir=/usr/share/doc/${PF}
}

src_compile() {
	cd doc
	cp ../doc_src/*.png .
	echo "User Guide for BurrTools ${PV}" > doc/userGuide.t2t
	cat ../doc_src/userGuide.t2t >> userGuide.t2t
	mkdir html
	../doc_src/txt2tags.py -t html -o - userGuide.t2t > userGuide.html
	htmldoc --format htmlsep --toclevels 2 --outdir html userGuide.html
	cd ..
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/${P}-A4.pdf
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}
