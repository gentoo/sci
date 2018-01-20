# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

[ "$PV" == "9999" ] && inherit git-r3

inherit eutils

DESCRIPTION="De novo transcriptome assembler"
HOMEPAGE="http://www.ebi.ac.uk/~zerbino/oases"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/dzerbino/oases.git"
	SRC_URI="http://www.ebi.ac.uk/~zerbino/oases/OasesManual.pdf"
	KEYWORDS=""
else
	SRC_URI="http://www.ebi.ac.uk/~zerbino/oases/oases_0.2.08.tgz
	http://www.ebi.ac.uk/~zerbino/oases/OasesManual.pdf"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-biology/velvet-1.2.08"

src_prepare(){
	epatch "${FILESDIR}"/Makefile.patch
}

src_install(){
	dobin oases
	dodoc README.md
	dodoc "${DISTDIR}"/OasesManual.pdf
}
