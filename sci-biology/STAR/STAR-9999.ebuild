# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 toolchain-funcs

DESCRIPTION="STAR aligner: align RNA-seq reads to reference genome uncompressed suffix arrays"
HOMEPAGE="http://code.google.com/p/rna-star/"
EGIT_REPO_URI="https://github.com/alexdobin/STAR.git"
# http://rna-star.googlecode.com/files/STARmanual_2.3.0.1.pdf

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

# contains bundled version sci-biology/htslib-0.0.1
DEPEND=""
RDEPEND="${DEPEND}"

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
