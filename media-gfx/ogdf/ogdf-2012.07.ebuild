# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="Open Graph Drawing Framework"
HOMEPAGE="http://www.ogdf.net/"
SRC_URI="http://www.ogdf.net/lib/exe/fetch.php/tech:${PN}.v${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="<=dev-lang/python-2.7.8"
RDEPEND="${DEPEND}"

S="${WORKDIR}/OGDF/"

# TODO:
# optional deps on:
#	- coin
#	- abacus

src_prepare(){
	epatch "${FILESDIR}/${P}-makeMakefile.config.patch"
	epatch "${FILESDIR}/${P}-makeMakefile.sh.patch"
}

src_configure(){
	./makeMakefile.sh
}

src_install () {
	dodir usr/include/ogdf
	dodir usr/lib/
	cp -R ${S}/ogdf/* ${D}usr/include/ogdf/
	dolib.so ${S}/_release/libOGDF.so 
	dodoc README.txt
}
