# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A program for generating standard InChI and InChIKeys"
HOMEPAGE="http://www.iupac.org/inchi/"
SRC_URI="http://www.iupac.org/inchi/download/STDINCHI-1-API.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/STDINCHI-1-API/STDINCHI/gcc_makefile"
	cd "${S}"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	dobin stdinchi-1
	dodoc ../../LICENSE ../../readme.txt ../../readme2.txt
}
