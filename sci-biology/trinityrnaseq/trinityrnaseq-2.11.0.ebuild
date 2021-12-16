# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

# Butterfly should not require any special compilation, as its written in Java and already provided as portable precompiled software ...

DESCRIPTION="Transcriptome assembler for RNA-seq reads"
HOMEPAGE="https://github.com/Trinotate/Trinotate.github.io/wiki"
SRC_URI="https://github.com/trinityrnaseq/trinityrnaseq/releases/download/v${PV}/${PN}-v${PV}.FULL_with_extendedTestData.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS="" # PERL5INC path is wrong when /usr/bin/Trinity is executed

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

S="${WORKDIR}/${PN}-v${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-2.11.0-fix-compilation.patch"
)

src_compile(){
	emake all
	emake plugins # bundled copies of TransDecoder, trimmomatic, fastool, parafly
}

src_install(){
	dodoc Chrysalis/chrysalis.notes
	dodoc Changelog.txt
	perl_set_version
	dobin Trinity
	perl_domodule util/*.pl
	dobin Inchworm/bin/*
	cd Chrysalis/bin  || die
	dobin BubbleUpClustering Chrysalis CreateIwormFastaBundle GraphFromFasta QuantifyGraph ReadsToTranscripts
	cd ../../util/R || die
	insinto /usr/share/"${PN}"/R
	doins *.R
	cd ../PBS || die
	insinto /usr/share/"${PN}"/PBS
	doins *
	cd .. || die
	cp -rp support_scripts misc "${ED}"/usr/share/"${PN}"/ || die
	cd "${S}" || die
	perl_domodule util/misc/PerlLib/*.pm PerlLib/*.pm
	perl_domodule PerlLib/KmerGraphLib/*.pm
	perl_domodule PerlLib/CDNA/*.pm
	perl_domodule PerlLib/Simulate/*.pm
	perl_domodule PerlLib/CanvasXpress/*.pm
	chmod a+rx -R "${ED}/${VENDOR_LIB}/${PN}"
}
