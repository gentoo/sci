# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Whole genome shotgun assembler (sparse de Bruijn graph) (now MEGAHIT)"
HOMEPAGE="https://github.com/aquaskyline/SOAPdenovo2
	http://gigascience.biomedcentral.com/articles/10.1186/2047-217X-1-18"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/libaio
	sci-biology/samtools:0.1-legacy"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"-src-r"${PV}" # version is 2.04-r240

src_prepare(){
	# pass to broken Makefile's a proper C++ compiler through the CC variable
	sed -e "s/CC = g++/CC = "$(tc-getCXX)"/;s/CFLAGS=/CFLAGS = ${CXXFLAGS} #/;s/-lbam/-lbam-0.1-legacy/" -i Makefile || die
	sed -e 's#-I./sparsePregraph/inc#-I/usr/include/bam-0.1-legacy -I./sparsePregraph/inc#' -i Makefile || die
	sed -e "s/CC = g++/CC = "$(tc-getCXX)"/;s/CFLAGS=/CFLAGS = ${CXXFLAGS} #/;s/-lbam/-lbam-0.1-legacy/" -i sparsePregraph/Makefile || die
	sed -e 's#-I./sparsePregraph/inc#-I/usr/include/bam-0.1-legacy -I./sparsePregraph/inc#' -i sparsePregraph/Makefile || die
	rm -f standardPregraph/*.a standardPregraph/inc/sam.h standardPregraph/inc/bam.h standardPregraph/inc/bgzf.h \
		sparsePregraph/inc/sam.h sparsePregraph/inc/bam.h sparsePregraph/inc/bgzf.h standardPregraph/inc/zlib.h \
		standardPregraph/inc/zconf.h sparsePregraph/inc/zlib.h sparsePregraph/inc/zconf.h standardPregraph/inc/*.so \
		sparsePregraph/*.a || die
	default
}

src_compile(){
	cd standardPregraph && emake -j1 63mer=1
	cd ../standardPregraph && emake -j1 127mer=1
	cd ../sparsePregraph && emake -j1
}

src_install(){
	doman "${FILESDIR}"/SOAPdenovo2.1
}
