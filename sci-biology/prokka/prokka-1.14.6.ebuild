# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Prokaryotic whole genome annotation pipeline"
HOMEPAGE="https://vicbioinformatics.com/software.prokka.shtml"
SRC_URI="https://github.com/tseemann/prokka/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sys-process/parallel
	sci-biology/bioperl
	sci-biology/prodigal
	|| ( sci-biology/ncbi-tools++ sci-biology/ncbi-blast+ )
	sci-biology/hmmer:*
	sci-biology/infernal
	sci-biology/exonerate
	sci-biology/barrnap"
DEPEND="${RDEPEND}"
# sci-biology/minced
# >=sci-biolohy/hmmer-3.1
# Aragorn
# >=RNAmmer-1.2
# >=HMMmmer-2.0 (that is not sci-biology/hmmer)
# SignalP >= 3.0
# sequin
# tbl2asn >= 23.0 from wget --mirror -nH -nd ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz

src_install() {
	default
	dobin bin/prokka
}
