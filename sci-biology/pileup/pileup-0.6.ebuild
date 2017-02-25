# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="SSAHA2-based pipeline to align reads"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/ssaha2/"
SRC_URI="ftp://ftp.sanger.ac.uk/pub4/resources/software/ssaha2/pileup.tgz"

# http://samtools.sourceforge.net/pileup.shtml
#
LICENSE="GRL"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/pileup_v"${PV}"

src_prepare(){
	sed -i "s/^CC= gcc/#CC= gcc/" ssaha_pileup/ssaha_pileup/makefile || die "sed failed to fix makefile"
	sed -i "s/^CFLAGS= -O2/#CFLAGS= -O2/" ssaha_pileup/ssaha_pileup/makefile || die "sed failed to fix makefile"

	for d in get_seqreads ssaha_split; do
		sed -i "s/^CC = cc/#CC = cc/" ssaha_pileup/other_codes/$d/Makefile || die "sed failed to fix Makefile"
		sed -i "s/^CFLAGS = -O4/#CFLAGS = -O4/" ssaha_pileup/other_codes/$d/Makefile || die "sed failed to fix Makefile"
	done

	for d in search_read ssaha_parseSNP; do
		sed -i "s/^CC = gcc/#CC = gcc/" ssaha_pileup/other_codes/$d/Makefile || die "sed failed to fix Makefile"
		sed -i "s/^CFLAGS = -Wall -O4/#CFLAGS = -Wall -O4/" ssaha_pileup/other_codes/$d/Makefile || die "sed failed to fix Makefile"
	done
}

src_compile(){
	cd ssaha_pileup/ssaha_pileup || die "Cannot cd to "${S}"ssaha_pileup/ssaha_pileup"
	default

	for d in get_seqreads ssaha_split ssaha_parseSNP search_read; do
		cd "${S}"/ssaha_pileup/other_codes/$d  || die "Cannot cd to "${S}"ssaha_pileup/other_codes/"$d
		make clean
		default
	done
}

src_install(){
	cd ssaha_pileup/ssaha_pileup || die "Cannot cd to "${S}"ssaha_pileup/ssaha_pileup"
	dobin ssaha_pileup ssaha_solexa ssaha_pairs ssaha_clean ssaha_mates ssaha_cigar ssaha_indel view_pileup ssaha_reads ssaha_merge ssaha_check-cigar "dobin failed"

	cd "${S}" || die
	for f in ssaha_pileup/other_codes/get_seqreads/get_seqreads \
		ssaha_pileup/other_codes/ssaha_split/ssaha_split \
		ssaha_pileup/other_codes/ssaha_parseSNP/ssaha_parseSNP \
		ssaha_pileup/other_codes/search_read/search_read; do
			dobin $f "dobin failed"
	done

	# TODO:
	# pileup_v0.6/ssaha_pileup/tag.pl

	# Finally, a tcsh shell script has to be created with full paths to ssaha2 binaries
	# convert the awk line from install.csh to a proper shellscript based on pileup.csh_src
}
