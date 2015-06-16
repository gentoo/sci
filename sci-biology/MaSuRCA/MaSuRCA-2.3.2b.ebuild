# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Assembler to combine Sanger, Roche 454 and Illumina Solexa reads"
HOMEPAGE="http://www.genome.umd.edu/masurca.html"
SRC_URI="ftp://ftp.genome.umd.edu/pub/MaSuRCA/MaSuRCA-"${PV}".tar.gz
		ftp://ftp.genome.umd.edu/pub/MaSuRCA/MaSuRCA_QuickStartGuide.pdf"

LICENSE="BSD GPL-2 GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl
		app-arch/bzip2"
RDEPEND="${DEPEND}
	>=sci-biology/quorum-0.2.1
	>=sci-biology/jellyfish-1.1.11"

# the ebuild mimics "${S}"/install.sh
src_configure(){
	cd jellyfish || die
	econf

	cd ../CA/kmer || die
	econf

	cd ../../SuperReads || die
	econf

	cd ../quorum || die
	econf --enable-relative-paths --with-relative-jf-path
}

src_compile(){
	cd jellyfish || die
	emake

	cd ../CA/kmer || die
	emake

	cd ../../CA/src || die
	emake

	cd ../SuperReads || die
	emake

	cd ../quorum || die
	emake
}

src_install(){
	dobin masurca
	dodoc sr_config_example.txt
}
