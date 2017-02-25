# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Prokaryotic whole genome annotation pipeline"
HOMEPAGE="http://www.bioinformatics.net.au/software.prokka.shtml"
SRC_URI="http://www.vicbioinformatics.com/prokka-"${PV}".tar.gz"
# 360MB

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-process/parallel
	sci-biology/bioperl
	sci-biology/prodigal
	|| ( sci-biology/ncbi-tools++ sci-biology/ncbi-blast+ )
	sci-biology/hmmer
	sci-biology/infernal
	sci-biology/exonerate
	sci-biology/barrnap"
# sci-biology/minced
# >=sci-biolohy/hmmer-3.1
# Aragorn
# >=RNAmmer-1.2
# >=HMMmmer-2.0 (that is not sci-biology/hmmer)
# SignalP >= 3.0
# sequin
# tbl2asn >= 23.0 from wget --mirror -nH -nd ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz
