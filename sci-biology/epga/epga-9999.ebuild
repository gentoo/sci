# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

[ "$PV" == "9999" ] && inherit git-r3

inherit toolchain-funcs

DESCRIPTION="De novo assembler using distribution of reads and insert size"
HOMEPAGE="https://github.com/bioinfomaticsCSU/EPGA"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/bioinfomaticsCSU/EPGA.git"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="GPL-3+"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

src_compile(){
	$(tc-getCXX) ${CFLAGS} main.cpp -o epga -lpthread
}

src_install(){
	dobin epga
	dodoc README.md
}
