# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Whole genome shotgun assembler using phrap (for Sanger-based reads)"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/phusion/"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/resources/software/phusion/phusion_pipeline_v2.1c.tar.gz"

LICENSE="all-rights-reserved" # temporarily placed value
# from http://genome.cshlp.org/content/13/1/81.full
# Availability
# Phusion is undergoing a rewrite of the code to make this a portable package. It will be made available free of charge to academic sites, but requires licensing for commercial use. For more information please contact the authors.
SLOT="0"
KEYWORDS="" # compile process does not exit upon errors
# one file does not compile
# x86_64-pc-linux-gnu-gcc  -O2 -pipe -maes -mpclmul -mpopcnt -mavx -march=native  -o contigoverlap  contigoverlap.o  -lm
# contigoverlap.o: In function `HashFasta':
# contigoverlap.c:(.text+0xbb1): relocation truncated to fit: R_X86_64_PC32 against symbol `n_Entry' defined in COMMON section in contigoverlap.o
# contigoverlap.o: In function `Reads_Overlap':
# contigoverlap.c:(.text+0x2637): relocation truncated to fit: R_X86_64_32S against symbol `qinfo' defined in COMMON section in contigoverlap.o
IUSE=""

DEPEND="app-shells/tcsh"
RDEPEND="${DEPEND}
	sci-biology/phrap
	dev-lang/perl"

# contains bundled ssaha
# file collision with sci-biology/shrimp on /usr/bin/fasta2fastq

S="${WORKDIR}"/"phusion_pipeline_v2.1c"

src_prepare(){
	cp -pf "${EPREFIX}"/usr/bin/phrap src/phrap/phrap.manylong || die
	# prevent file collision with sci-biology/shrimp-2.2.3 and sci-biology/phusion2-3.0
	sed -e "s#fasta2fastq#fasta2fastq_"${PN}"#" -i src/fasta2fastq/fasta2fastq.c \
		src/fasta2fastq/Makefile || die
	sed -e "s#ctgreads.pl#ctgreads_"${PN}".pl#" -i src/Tcsh_scripts/*.csh || die
	mv src/fasta2fastq/fasta2fastq.c src/fasta2fastq/fasta2fastq_"${PN}".c || die
	mv src/Perl_scripts/ctgreads.pl src/Perl_scripts/ctgreads_"${PN}".pl || die
	find . -name Makefile | while read f; do
		sed -e "s/^CC =/CC = $(tc-getCC) #/" -i "$f" || die
		sed -e "s/^ CFLAGS2 =/ CFLAGS2 = ${CFLAGS} #/" -i "$f" || die
		sed -e "s/^CFLAGS =/CFLAGS = ${CFLAGS} #/" -i "$f" || die
		sed -e "s/^ CFLAGS =/ CFLAGS = ${CFLAGS} #/" -i "$f" || die
	done
}

src_compile(){
	tcsh install.csh || csh install.csh || die
}

src_install(){
	dobin bin/*
	dodoc README.1st releaseNote_v2.1c doc/*
}
