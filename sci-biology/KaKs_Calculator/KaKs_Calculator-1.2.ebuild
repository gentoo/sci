# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Calculate nonsynonymous (Ka) and synonymous (Ks) substitution rates"
HOMEPAGE="https://bigd.big.ac.cn/tools/kaks"
SRC_URI="
	https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/kaks-calculator/KaKs_Calculator"${PV}".tar.gz -> ${P}.tar.gz
	https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/kaks-calculator/parseFastaIntoAXT.pl
	https://raw.githubusercontent.com/WilsonSayresLab/AlignmentProcessor/master/KaKs_Calculator/${PN}${PV}/KaKs_CalculatorDOC.pdf -> ${P}_manual.pdf
	https://s3.amazonaws.com/fumba.me/share+files/1-s2.0-S1672022907600072-main.pdf -> ${PN}-Zhang_et_al_2006.pdf"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${PN}"-1.2_strlen_was_not_declared.patch )

# ParaAT: A parallel tool for constructing multiple protein-coding DNA alignments
# http://cbb.big.ac.cn/software
# https://www.sciencedirect.com/science/article/pii/S0006291X12003518
DEPEND="sci-biology/ParaAT"
RDEPEND="
	dev-lang/perl
	sci-biology/paml
	${DEPEND}"

S="${WORKDIR}"/KaKs_Calculator"${PV}"

src_prepare(){
	sed -e "s/^CC = g++/CC="$(tc-getCXX)"/; s/^CFLAGS/#CFLAGS/" -i src/makefile  || die
	default
}

src_compile(){
	cd src || die
	default
}

src_install(){
	dobin "${DISTDIR}"/parseFastaIntoAXT.pl
	dobin src/{KaKs_Calculator,AXTConvertor,ConPairs}
	dodoc "${DISTDIR}"/${P}_manual.pdf "${DISTDIR}"/${PN}-Zhang_et_al_2006.pdf
}
