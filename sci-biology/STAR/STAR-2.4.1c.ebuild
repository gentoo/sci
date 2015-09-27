# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="STAR aligner: align RNA-seq reads to reference genome uncompressed suffix arrays"
HOMEPAGE="http://code.google.com/p/rna-star/"
SRC_URI="https://github.com/alexdobin/STAR/archive/STAR_"${PV}".tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# sci-biology/htslib
DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/STAR-STAR_"${PV}"

# contains bundled STAR-Fusion
src_prepare(){
	sed -e "s/= gcc/= $(tc-getCC)/;s/-O2/${CFLAGS}/g" -i source/htslib/Makefile || die
	sed -e "s/-O3/${CFLAGS}/g" -i source/Makefile || die
}

src_compile(){
	cd source || die
	emake STAR
}

src_install(){
	dobin source/STAR
	dodoc doc/STARmanual.pdf
}
