# Copyright 1999-2014 Gentoo Foundation
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
RDEPEND="${DEPEND}"
	#sci-biology/quorum"

# the ebuild mimics "${S}"/install.sh
src_configure(){
	cd jellyfish-1.1.11 || die
	econf

	cd ../jellyfish-2.0.0rc1 || die
	econf --program-suffix=-2.0

	cd ../CA/kmer || die
	sh ./configure.sh
	econf

	cd ../../SuperReads-0.3.2 || die
	econf

	cd ../quorum-0.3.2 || die
	econf --enable-relative-paths --with-relative-jf-path
}

src_compile(){
	cd jellyfish-1.1.11 || die
	emake

	cd ../jellyfish-2.0.0rc1 || die
	emake

	cd ../CA/kmer || die
	emake

	cd ../../CA/src || die
	emake

	cd ../SuperReads-0.3.2 || die
	emake

	cd ../quorum-0.3.2 || die
	emake
}

src_install(){
	dobin masurca
	dodoc sr_config_example.txt
}
