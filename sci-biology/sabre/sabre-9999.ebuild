# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Barcode demultiplexing and trimming tool for Illumina FastQ files"
HOMEPAGE="https://github.com/najoshi/sabre"
if [ "$PV" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/najoshi/sabre.git"
else
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="MIT" # almost verbatim
SLOT="0"

DEPEND="virtual/zlib:="
RDEPEND="${DEPEND}"

src_prepare(){
	default
	sed -e "s#OPT = -O3#OPT = ${CFLAGS}#" \
		-e "s#CC = gcc#CC = $(tc-getCC)#" -i Makefile || die
}

src_install(){
	dobin sabre
}
