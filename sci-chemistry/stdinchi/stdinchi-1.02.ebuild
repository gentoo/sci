# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A program for generating standard InChI and InChIKeys"
HOMEPAGE="http://www.iupac.org/inchi/"
SRC_URI="http://www.iupac.org/inchi/download/STDINCHI-1-API.zip
	doc? ( http://www.iupac.org/inchi/download/STDINCHI-1-DOC.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/STDINCHI-1-API/STDINCHI/gcc_makefile"
	cd "${S}"

	epatch "${FILESDIR}/${P}-makefile.patch" || die "Failed to apply ${P}-makefile.patch"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	dobin stdinchi-1
	cd ../..
	dodoc readme.txt readme2.txt
	if use doc ; then
		cd "${WORKDIR}/STDINCHI-1-DOC/"
		docinto doc
		dodoc *.pdf readme.txt
		docinto doc/DOC-101
		dodoc DOC-101/*.pdf DOC-101/readme.txt
		docinto doc/DOC-102B
		dodoc DOC-102B/*.pdf DOC-102B/readme.txt
	fi
}
