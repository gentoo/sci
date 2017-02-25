# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="De novo transcriptome assembler"
HOMEPAGE="http://www.ebi.ac.uk/~zerbino/oases"
SRC_URI="http://www.ebi.ac.uk/~zerbino/oases/oases_0.2.08.tgz
	http://www.ebi.ac.uk/~zerbino/oases/OasesManual.pdf"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-biology/velvet-1.2.08"

S="${WORKDIR}"/oases_0.2.8

src_prepare(){
	epatch "${FILESDIR}"/Makefile.patch
	sed -e 's#cleanobj velvet oases doc#oases#' -i Makefile || die
}

src_install(){
	dobin oases
	dodoc README.md
	dodoc "${DISTDIR}"/OasesManual.pdf
}
