# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="De novo transcriptome assembler"
HOMEPAGE="http://www.ebi.ac.uk/~zerbino/oases"
if [ "$PV" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dzerbino/oases.git"
	SRC_URI="http://www.ebi.ac.uk/~zerbino/oases/OasesManual.pdf"
else
	SRC_URI="http://www.ebi.ac.uk/~zerbino/oases/oases_0.2.08.tgz
		http://www.ebi.ac.uk/~zerbino/oases/OasesManual.pdf"
	S="${WORKDIR}/oases_0.2.8"
	KEYWORDS=""
	# fails to find globals.h, but which globals.h does it want?
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-biology/velvet-1.2.08"

PATCHES=(
	"${FILESDIR}/Makefile.patch"
)

src_prepare(){
	default
	sed -e 's#cleanobj velvet oases doc#oases#' -i Makefile || die
}

src_install(){
	dobin oases
	dodoc README.md
	dodoc "${DISTDIR}"/OasesManual.pdf
}
