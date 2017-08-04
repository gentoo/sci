# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="de Bruijn and OLC assembler for Sanger, Roche 454, Illumina, Pacbio, Nanopore"
HOMEPAGE="http://www.genome.umd.edu/masurca.html
	http://bioinformatics.oxfordjournals.org/content/29/21/2669
	http://biorxiv.org/content/biorxiv/early/2016/07/26/066100.full.pdf"
SRC_URI="${P}.tar.gz
	ftp://ftp.genome.umd.edu/pub/MaSuRCA/MaSuRCA_QuickStartGuide.pdf"

LICENSE="BSD GPL-2 GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-lang/perl-5.8
		app-arch/bzip2"
RDEPEND="${DEPEND}"

RESTRICT="fetch"

src_configure(){
	./install.sh || die
}

src_compile(){
	./install.sh || die
}

src_install(){
	dobin masurca
	dodoc sr_config_example.txt
}
