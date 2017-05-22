# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Population genetics analysis package"
HOMEPAGE="http://www.popgen.dk/angsd"
EGIT_REPO_URI="https://github.com/ANGSD/angsd.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-lang/R
	sci-libs/htslib:0="
RDEPEND="${DEPEND}"

# https://github.com/ANGSD/angsd/issues/9
src_prepare(){
	default
	sed \
		-e 's@FLAGS=-O3@FLAGS=@' \
		-e 's@HTSLIB = .*@HTSLIB = -lhts@' \
		-e 's@all: htshook angsd misc@all: angsd misc@' \
		-i Makefile || die
	sed \
		-e 's@HTSLIB = .*@HTSLIB = -lhts@' \
		-e 's@HTSDIR = .*@HTSDIR = /usr/include@' \
		-i misc/Makefile || die
	sed \
		-e 's@include "../htslib/bgzf.h@include "bgzf.h@' \
		-i misc/thetaStat.cpp || die
}

src_compile(){
	emake HTS=/usr/include
}

src_install(){
	dobin angsd
	dodoc README.md
	cd misc || die
	dobin \
		supersim thetaStat realSFS emOptim2 msToGlf smartCount \
		printIcounts splitgl contamination NGSadmix
}
