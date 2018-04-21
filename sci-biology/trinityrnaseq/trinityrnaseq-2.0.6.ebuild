# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

# Butterfly should not require any special compilation, as its written in Java and already provided as portable precompiled software ...
# There is bundled jellyfish-1.1.11 source tree

DESCRIPTION="Transcriptome assembler for RNA-seq reads"
HOMEPAGE="http://trinityrnaseq.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/parafly
	>=sci-biology/jellyfish-2.1.4:2
	sci-biology/samtools:0.1-legacy
	>=sci-biology/GAL-0.2.1
	dev-perl/IO-All"
# ReleaseNotes mentions that <sci-biology/samtools-1.1 is needed
# version of bundled jellyfish is 2.1.4

# optionally install https://github.com/HpcGridRunner/HpcGridRunner/releases

#src_compile(){
#	emake all
#	emake plugins # bundled copies of TransDecoder, trimmomatic, fastool, parafly
#}

src_install(){
	perl_set_version
	dobin Trinity util/*.pl
	# should become a new package depending on dev-perl/IO-All
	dobin trinity-plugins/fstrozzi-Fastool-7c3e034f05/fastool
	dodoc trinity-plugins/fstrozzi-Fastool-7c3e034f05/README.md
	#
	insinto /usr/share/"${PN}"/util
	rm -rf trinity-plugins/GAL_0.2.1 util/fasta_tool
	doins -r util/*
	#
	dobin Inchworm/bin/*
	cd Chrysalis || die
	dobin MakeDepend checkLock BreakTransByPairs Chrysalis GraphFromFasta IsoformAugment JoinTransByPairs QuantifyGraph ReadsToTranscripts RunButterfly TranscriptomeFromVaryK analysis/ReadsToComponents.pl
	cd "${S}" || die
	insinto "${VENDOR_LIB}/${PN}"
	doins util/misc/PerlLib/*.pm PerlLib/*.pm
	insinto "${VENDOR_LIB}/${PN}"/KmerGraphLib
	doins PerlLib/KmerGraphLib/*.pm
	insinto "${VENDOR_LIB}/${PN}"/CDNA
	doins PerlLib/CDNA/*.pm
	insinto "${VENDOR_LIB}/${PN}"/HPC
	doins PerlLib/HPC/*.pm
	insinto "${VENDOR_LIB}/${PN}"/Simulate
	doins PerlLib/Simulate/*.pm
	insinto "${VENDOR_LIB}/${PN}"/CanvasXpress
	doins PerlLib/CanvasXpress/*.pm
	chmod a+rx -R "${ED}/${VENDOR_LIB}/${PN}"
}
