# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

[ "$PV" == "9999" ] && inherit git-r3

inherit eutils toolchain-funcs

DESCRIPTION="Extend partial transcripts with sequence from other reads or genomic contigs"
HOMEPAGE="https://github.com/baoe/BRANCH"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/baoe/BRANCH"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="Artistic-2"
SLOT="0"
IUSE=""

DEPEND="
	sci-biology/blat
	sci-libs/lemon"
RDEPEND="${DEPEND}"

src_compile(){
	einfo "$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -o BRANCH BRANCH.cpp -lemon -lpthread"
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -o BRANCH/BRANCH BRANCH/BRANCH.cpp -lemon -lpthread || die
}

src_install(){
	dobin BRANCH/BRANCH
	dodoc README.md
}
