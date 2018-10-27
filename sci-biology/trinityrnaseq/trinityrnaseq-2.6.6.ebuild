# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

# Butterfly should not require any special compilation, as its written in Java and already provided as portable precompiled software ...

DESCRIPTION="Transcriptome assembler for RNA-seq reads"
HOMEPAGE="http://trinityrnaseq.github.io/"
SRC_URI="https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS="" # PERL5INC path is wrong when /usr/bin/Trinity is executed
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/parafly
	>=sci-biology/jellyfish-2.2.6:2
	>=sci-libs/htslib-1.2.1
	>=sci-biology/samtools-1.3:0
	>=sci-biology/trimmomatic-0.36
	>=sci-biology/GAL-0.2.1
	dev-perl/IO-All
	sci-biology/seqtools"
# optionally install https://github.com/HpcGridRunner/HpcGridRunner/releases
# has the following "plugins" (aka bundled 3rd-party code)
# slclust
# DEXseq_util
# COLLECTL
# ParaFly-0.1.0

S="${WORKDIR}"/trinityrnaseq-Trinity-v"${PV}"

src_prepare(){
	epatch "${FILESDIR}"/"${P}"-disable_some_plugins.patch
}

#src_compile(){
#	emake all
#	emake plugins # bundled copies of TransDecoder, trimmomatic, fastool, parafly
#}

src_install(){
	dodoc Chrysalis/chrysalis.notes
	dodoc Changelog.txt
	perl_set_version
	dobin Trinity util/*.pl
	dobin Inchworm/bin/*
	cd Chrysalis  || die
	dobin MakeDepend checkLock BreakTransByPairs BubbleUpClustering Chrysalis CreateIwormFastaBundle GraphFromFasta GraphFromFasta_MPI IsoformAugment JoinTransByPairs QuantifyGraph ReadsToTranscripts ReadsToTranscripts_MPI ReadsToTranscripts_MPI_chang RunButterfly TranscriptomeFromVaryK analysis/ReadsToComponents.pl
	cd ../util/R || die
	insinto /usr/share/"${PN}"/R
	doins *.R
	cd ../PBS || die
	insinto /usr/share/"${PN}"/PBS
	doins *
	cd .. || die
	cp -rp support_scripts misc "${ED}"/usr/share/"${PN}"/ || die
	cd "${S}" || die
	insinto "${VENDOR_LIB}/${PN}"
	doins util/misc/PerlLib/*.pm PerlLib/*.pm
	insinto "${VENDOR_LIB}/${PN}"/KmerGraphLib
	doins PerlLib/KmerGraphLib/*.pm
	insinto "${VENDOR_LIB}/${PN}"/CDNA
	doins PerlLib/CDNA/*.pm
	insinto "${VENDOR_LIB}/${PN}"/Simulate
	doins PerlLib/Simulate/*.pm
	insinto "${VENDOR_LIB}/${PN}"/CanvasXpress
	doins PerlLib/CanvasXpress/*.pm
	chmod a+rx -R "${ED}/${VENDOR_LIB}/${PN}"
}
