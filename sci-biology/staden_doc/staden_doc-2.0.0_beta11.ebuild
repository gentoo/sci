# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Documentation files for the staden package"
HOMEPAGE="https://sourceforge.net/projects/staden"
SRC_URI="https://sourceforge.net/projects/staden/files/staden/${PV/_beta/b}/staden_doc-${PV/_beta/b}-src.tar.gz"

LICENSE="staden"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-lang/perl
	app-text/texlive
	app-text/texi2html"
BDEPEND="app-editors/emacs"
RDEPEND="${DEPEND} ${BDEPEND}"

S="${WORKDIR}"/staden_doc-${PV/_beta/b}-src

# do not use texi2html-5 because it fails with:
# texi2html -menu -verbose -split_chapter -index_chars interface.htmlinfo
# Unknown option: index_char
# src_prepare(){
# 	default
# 	# avoid running bundled texi2html code
# 	sed -e "s#./tools/texi2html#texi2html#" -i manual/Makefile || die
# }

src_compile(){
	cd manual || die
	emake -j1 spotless || die
	cd .. || die
	emake -j1 unix PAPER=A4
}

src_install(){
	emake -j1 install prefix="${D}"/usr
	dodoc gkb547_gml.pdf
}
