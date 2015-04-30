# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

# Butterfly should not require any special compilation, as its written in Java and already provided as portable precompiled software ...
# There is bundled jellyfish-1.1.11 source tree

DESCRIPTION="Transcriptome assembler for RNA-seq reads"
HOMEPAGE="http://sourceforge.net/projects/trinityrnaseq"
SRC_URI="http://downloads.sourceforge.net/project/trinityrnaseq/trinityrnaseq_r20140413p1.tar.gz"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/trinityrnaseq_r20140413p1

src_prepare(){
	epatch "${FILESDIR}"/sort.patch
	epatch "${FILESDIR}"/r3590_chmod.patch
}

src_install(){
	perl_set_version
	dobin Trinity util/*.pl util/fasta_tool
	dobin Inchworm/bin/*
	cd Chrysalis
	dobin MakeDepend checkLock BreakTransByPairs Chrysalis GraphFromFasta IsoformAugment JoinTransByPairs QuantifyGraph ReadsToTranscripts RunButterfly TranscriptomeFromVaryK analysis/ReadsToComponents.pl
	cd ${S} || die
	insinto ${VENDOR_LIB}/${PN}
	dobin util/misc/PerlLib/*.pm PerlLib/*.pm
	insinto ${VENDOR_LIB}/${PN}/KmerGraphLib
	dobin PerlLib/KmerGraphLib/*.pm
	insinto ${VENDOR_LIB}/${PN}/CDNA
	dobin PerlLib/CDNA/*.pm
	insinto ${VENDOR_LIB}/${PN}/HTC
	dobin PerlLib/HTC/*.pm
	insinto ${VENDOR_LIB}/${PN}/Simulate
	dobin PerlLib/Simulate/*.pm
}
