# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2

[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="Population genetics analysis package"
HOMEPAGE="http://www.popgen.dk/angsd"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/ANGSD/angsd.git"
	KEYWORDS=""
else
	EGIT_REPO_URI="https://github.com/ANGSD/angsd.git"
	EGIT_BRANCH="0.700"
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="dev-lang/R
	sci-libs/htslib"
RDEPEND="${DEPEND}"

# https://github.com/ANGSD/angsd/issues/9
src_prepare(){
	sed -e 's@FLAGS=-O3@FLAGS=@' \
		-e 's@HTSLIB = .*@HTSLIB = -lhts@' \
		-e 's@all: htshook angsd misc@all: angsd misc@' -i Makefile || die
	sed -e 's@HTSLIB = .*@HTSLIB = -lhts@' \
		-e 's@HTSDIR = .*@HTSDIR = /usr/include@' -i misc/Makefile || die
	sed -e 's@include "../htslib/bgzf.h@include "bgzf.h@' -i misc/thetaStat.cpp || die
}

src_compile(){
	emake HTS=/usr/include
}

src_install(){
	dobin angsd
	dodoc README.md
	cd misc || die
	dobin supersim thetaStat realSFS emOptim2 msToGlf smartCount printIcounts splitgl contamination NGSadmix
}
