# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="Metagenome assembler using succinct de Bruijn graph approach with CUDA"
HOMEPAGE="https://github.com/voutcn/megahit
	http://bioinformatics.oxfordjournals.org/content/31/10/1674.abstract"
EGIT_REPO_URI="https://github.com/voutcn/megahit.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+openmp"

DEPEND=""
RDEPEND="${DEPEND}
	sys-libs/zlib"
# >=gcc-4.4

# use make use_gpu=1 to compile it and turn on --use-gpu to activate GPU acceleration when running megahit

src_prepare(){
	default
	sed -e "s#^CXXFLAGS = -g -O2#CXXFLAGS = ${CFLAGS}#" -i Makefile || die
}

src_install(){
	dobin megahit megahit_toolkit megahit_sdbg_build megahit_asm_core
	dodoc README.md
}
