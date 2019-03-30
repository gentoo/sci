# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="Calculate nonsynonymous (Ka) and synonymous (Ks) substitution rates"
HOMEPAGE="https://code.google.com/p/kaks-calculator
	https://sourceforge.net/projects/kakscalculator2/
	https://www.sciencedirect.com/science/article/pii/S1672022910600083"
SRC_URI="
	https://netcologne.dl.sourceforge.net/project/kakscalculator2/${PN}${PV}.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/WilsonSayresLab/AlignmentProcessor/master/${PN}/${PN}${PV}/${PN}${PV}_manual.pdf -> ${P}_manual.pdf
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
	dobin src/{KaKs_Calculator,AXTConvertor,ConPairs}
	dodoc "${DISTDIR}"/${P}_manual.pdf "${DISTDIR}"/${PN}-Zhang_et_al_2006.pdf
}
