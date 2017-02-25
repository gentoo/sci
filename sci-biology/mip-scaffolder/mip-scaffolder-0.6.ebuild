# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Scaffold contigs using ABI Solid or Illumina mate pair info"
HOMEPAGE="http://www.cs.helsinki.fi/u/lmsalmel/mip-scaffolder"
SRC_URI="http://www.cs.helsinki.fi/u/lmsalmel/mip-scaffolder/"${P}".tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sci-libs/lemon
	sci-mathematics/lpsolve
	dev-lang/perl"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e 's:/home/user/lp-solve/:/usr/include/lpsolve/:; s:/home/user/lemon/:/usr/include/lemon:; s:/home/user/mip-scaffolder-0.6/:/usr/bin:' -i Makefile
	find . -name Makefile | while read f; do sed -e "s:CC=g++:CC=$(tc-getCXX):; s:CFLAGS=-Wall -g -O9:CFLAGS=${CXXFLAGS}:" -i $f; done
	sed -e 's:$(LPSOLVEROOT)/liblpsolve55.a:-llpsolve55:' -i split-scaffold/Makefile
}

src_install(){
	dobin combine-scaffold/combine-scaffold filter-mappings/filter-mappings split-scaffold/split-scaffold write-scaffold/write-scaffold scripts/*.pl scripts/*.sh
	dodoc README
}
