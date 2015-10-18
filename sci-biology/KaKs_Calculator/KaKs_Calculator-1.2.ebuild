# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Calculate nonsynonymous (Ka) and synonymous (Ks) substitution rates"
HOMEPAGE="https://code.google.com/p/kaks-calculator"
SRC_URI="https://kaks-calculator.googlecode.com/files/KaKs_Calculator"${PV}".tar.gz
	https://kaks-calculator.googlecode.com/files/parseFastaIntoAXT.pl"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/ParaAT"
RDEPEND="
	dev-lang/perl
	${DEPEND}"

S="${WORKDIR}"/KaKs_Calculator"${PV}"

src_prepare(){
	sed -e "s/^CC = g++/CC="$(tc-getCXX)"/; s/^CFLAGS/#CFLAGS/" -i src/makefile
}

src_compile(){
	cd src || die
	default
}

src_install(){
	dobin "${DISTDIR}"/parseFastaIntoAXT.pl
	dobin src/{KaKs_Calculator,AXTConvertor,ConPairs}
}
