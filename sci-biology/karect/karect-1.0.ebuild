# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Error-correct mismatches and InDels of raw reads incl. paired-end"
HOMEPAGE="https://github.com/aminallam/karect
	http://bioinformatics.oxfordjournals.org/content/31/21/3421.abstract"
SRC_URI="https://github.com/aminallam/karect/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# actually fetches aminallam-karect-v1.0-0-gba3ad54.tar.gz
# https://github.com/aminallam/karect.git

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

src_compile(){
	$(tc-getCXX) ${CXXFLAGS} -pthread -lpthread karect.cpp -o karect || die
}

src_install(){
	dobin karect
	dodoc karect_manual.pdf README README.md
}
