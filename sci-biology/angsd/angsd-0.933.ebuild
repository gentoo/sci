# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Population genetics analysis package"
HOMEPAGE="http://www.popgen.dk/angsd"
SRC_URI="https://github.com/ANGSD/angsd/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

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
	einstalldocs
	dobin angsd
	cd misc || die
	dobin \
		supersim haploToPlink ibs thetaStat realSFS msToGlf msHOT2glf smartCount \
		printIcounts splitgl contamination contamination2 NGSadmix ngsPSMC scounts
}
