# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="de Bruijn and OLC assembler for Sanger, Roche 454, Illumina, Pacbio, Nanopore"
HOMEPAGE="http://www.genome.umd.edu/masurca.html
	http://bioinformatics.oxfordjournals.org/content/29/21/2669
	https://github.com/alekseyzimin/masurca"
SRC_URI="https://github.com/alekseyzimin/masurca/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD GPL-2 GPL-3"
SLOT="0"
# Known to produce build failure:
# https://github.com/alekseyzimin/masurca/issues/323
KEYWORDS=""

DEPEND="
	>=dev-lang/perl-5.8
	app-arch/bzip2
"
RDEPEND="${DEPEND}"

src_compile(){
	./install.sh || die
}
src_install(){
	dobin masurca
}
