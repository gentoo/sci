# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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

pkg_setup() {
	use openmp && ! tc-has-openmp && die "Please switch to an openmp compatible compiler"
}

src_prepare(){
	default
	if [[ $(tc-getCXX) =~ g++ ]]; then
		local eopenmp=-fopenmp
	elif [[ $(tc-getCXX) =~ cxx ]]; then
		local eopenmp=-openmp
		sed -e "s#-fopenmp#-openmp#" -i Makefile || die
	else
		elog "Cannot detect compiler type so not setting openmp support"
	fi
	sed -e "s#^CXXFLAGS = -g -O2#CXXFLAGS = ${CFLAGS}#" -i Makefile || die
}

src_install(){
	dobin megahit megahit_toolkit megahit_sdbg_build megahit_asm_core
	dodoc README.md
}
