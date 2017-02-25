# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

[ "$PV" == "9999" ] && inherit git-r3

inherit toolchain-funcs

DESCRIPTION="Barcode demultiplexing and trimming tool for Illumina FastQ files"
HOMEPAGE="https://github.com/najoshi/sabre"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/najoshi/sabre.git"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="MIT" # almost verbatim
SLOT="0"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${S}"/src

src_prepare(){
	sed -e "s#OPT = -O3#OPT = ${CFLAGS}#" \
		-e "s#CC = gcc#CC = $(tc-getCC)#" -i Makefile || die
}

src_install(){
	dobin sabre
}
