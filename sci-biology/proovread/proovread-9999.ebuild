# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

[ "$PV" == "9999" ] && inherit git-r3

inherit perl-functions toolchain-funcs

DESCRIPTION="Error correct PacBio subreads using Illumina reads"
HOMEPAGE="https://github.com/BioInf-Wuerzburg/proovread"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/BioInf-Wuerzburg/proovread"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86" # issue #125
fi

LICENSE="Artistic-2 GPL-3"
SLOT="0"
IUSE=""

# needs Fasta::Parser
RDEPEND="
	>=dev-lang/perl-5.10
	dev-perl/Log-Log4perl
	dev-perl/File-Which
	>=sci-biology/ncbi-tools++-2.2.24
	>=sci-biology/samtools-1.1"
DEPEND="${RDEPEND}
	>=sci-biology/shrimp-2
	sci-biology/blasr"

src_install(){
	cd bin || die
	dobin ChimeraToSeqFilter.pl dazz2sam ccseq bam2cns test_cfg.pl siamaera samfilter sam2cns proovread-flex proovread
	cd ../util/bwa || die
	dobin bwa-proovread # xa2multi.pl qualfa2fq.pl libbwa.a bwa.1
	cd ../../util/SeqFilter || die
	dobin bin/SeqFilter
	cd ../../util/SeqChunker || die
	dobin bin/*
	cd ../../lib || die
	perl_domodule -r -C ${PN} *
	# cd ../util/blasr-1.3.1 || die
	# dobin blasr
	# dodoc LICENSE.txt
}

pkg_postinst(){
	einfo "Proovread uses its own, modified version of bwa as bwa-proovread"
	einfo "with linked in libbwa.a. It also bundles shrimp2 and blasr"
}
