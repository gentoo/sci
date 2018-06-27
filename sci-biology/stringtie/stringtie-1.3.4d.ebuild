# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Transcriptome assembler and RNA-Seq analysis on BAM files aka cufflinks"
HOMEPAGE="https://ccb.jhu.edu/software/stringtie
	https://github.com/gpertea/stringtie"
SRC_URI="http://ccb.jhu.edu/software/stringtie/dl/${P}.tar.gz"

LICENSE="Artistic-2 MIT" # MIT from bundled samtools-0.1.18
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# contains bundled and modified samtools-0.1.18
# https://github.com/gpertea/stringtie/issues/185#issuecomment-400128090
#
# contains bundled gclib (0.9.8?), a modified version?
# https://github.com/gpertea/stringtie/issues/186#issuecomment-400131844
DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/Makefile.patch )

src_compile(){
	emake release
}

src_install(){
	dobin stringtie
	dodoc README
}
