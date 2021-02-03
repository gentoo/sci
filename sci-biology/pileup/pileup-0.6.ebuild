# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SSAHA2-based pipeline to align reads"
HOMEPAGE="https://www.sanger.ac.uk/resources/software/ssaha2/"
SRC_URI="ftp://ftp.sanger.ac.uk/pub4/resources/software/ssaha2/pileup.tgz -> ${P}.tgz"

# http://samtools.sourceforge.net/pileup.shtml
#
LICENSE="GRL"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/pileup_v${PV}"

src_prepare(){
	default
	sed -i -e "s/^CC= gcc/#CC= gcc/" \
		-e "s/^CFLAGS= -O2/#CFLAGS= -O2/" \
		ssaha_pileup/ssaha_pileup/makefile || die "sed failed to fix makefile"

	for d in get_seqreads ssaha_split; do
		sed -i -e "s/^CC = cc/#CC = cc/" \
			-e "s/^CFLAGS = -O4/#CFLAGS = -O4/" \
			ssaha_pileup/other_codes/$d/Makefile || die "sed failed to fix Makefile"
	done

	for d in search_read ssaha_parseSNP; do
		sed -i -e "s/^CC = gcc/#CC = gcc/" \
			-e "s/^CFLAGS = -Wall -O4/#CFLAGS = -Wall -O4/" \
		ssaha_pileup/other_codes/$d/Makefile || die "sed failed to fix Makefile"
	done
}

src_compile(){
	cd ssaha_pileup/ssaha_pileup || die "Cannot cd to "${S}"ssaha_pileup/ssaha_pileup"
	default

	for d in get_seqreads ssaha_split ssaha_parseSNP search_read; do
		cd "${S}"/ssaha_pileup/other_codes/$d  || die "Cannot cd to "${S}"ssaha_pileup/other_codes/"$d
		emake clean
		default
	done
}

src_install(){
	cd ssaha_pileup/ssaha_pileup || die "Cannot cd to "${S}"ssaha_pileup/ssaha_pileup"
	dobin ssaha_pileup ssaha_solexa ssaha_pairs ssaha_clean ssaha_mates ssaha_cigar ssaha_indel view_pileup ssaha_reads ssaha_merge ssaha_check-cigar

	cd "${S}/ssaha_pileup/other_codes" || die
	dobin get_seqreads/get_seqreads ssaha_split/ssaha_split ssaha_parseSNP/ssaha_parseSNP search_read/search_read

	# TODO:
	# pileup_v0.6/ssaha_pileup/tag.pl

	# Finally, a tcsh shell script has to be created with full paths to ssaha2 binaries
	# convert the awk line from install.csh to a proper shellscript based on pileup.csh_src
}
