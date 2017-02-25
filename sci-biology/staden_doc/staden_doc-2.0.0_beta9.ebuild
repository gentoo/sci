# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Documentation files for the staden package"
HOMEPAGE="http://sourceforge.net/projects/staden"
SRC_URI="http://sourceforge.net/projects/staden/files/staden/${PV/_beta/b}/staden_doc-${PV/_beta/b}-src.tar.gz"
# https://sourceforge.net/p/staden/code/HEAD/tree/staden/trunk/doc/

LICENSE="staden"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl
	app-text/texlive
	app-text/texi2html"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/staden_doc-${PV/_beta/b}-src

# do not use texi2html-5 because it fails with:
# texi2html -menu -verbose -split_chapter -index_chars interface.htmlinfo
# Unknown option: index_char
# src_prepare(){
# 	# avoid running bundled texi2html code
# 	sed -e "s#./tools/texi2html#texi2html#" -i manual/Makefile || die
# }

src_compile(){
	cd manual || die
	make -j 1 spotless || die
	cd .. || die
	emake -j 1 unix PAPER=A4
}

src_install(){
	emake -j 1 install prefix="${D}"/usr
	dodoc gkb547_gml.pdf
}
