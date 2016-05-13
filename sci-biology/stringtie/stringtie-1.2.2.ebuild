# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Transcriptome assembler and RNA-Seq analysis on BAM files aka cufflinks"
HOMEPAGE="https://ccb.jhu.edu/software/stringtie
	https://github.com/gpertea/stringtie"
SRC_URI="http://ccb.jhu.edu/software/stringtie/dl/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# contains bundled gclib
DEPEND="sci-biology/samtools:0.1-legacy" # bundled samtools-0.1.18
RDEPEND="${DEPEND}"

src_compile(){
	emake release
}

src_install(){
	dobin stringtie
	dodoc README
}
