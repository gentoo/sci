# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="VCF/BED utils, Genotype Phenotype Association Toolkit (GPAT++)"
HOMEPAGE="https://github.com/vcflib/vcflib"
SRC_URI="https://github.com/vcflib/vcflib/releases/download/v${PV}/${P}-src.tar.gz"

# vcflib is incorporated into several projects, such as freebayes

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS=""
IUSE="openmp"

DEPEND="
	sys-libs/zlib
	sci-libs/htslib
"
RDEPEND="${DEPEND}"
# contains bundled sci-biology/htslib ?
# see also ./include for possible traces of other bundled sw

S="${WORKDIR}/${PN}"

src_prepare(){
	cmake_src_prepare
	sed -e "s/^CXX = g++/CXX = $(tc-getCXX)/" -i Makefile || die
	sed -e "s/^CXXFLAGS = -O3/CXXFLAGS = ${CXXFLAGS}/" -i Makefile || die
	# openmp detection stolen from velvet-1.2.10.ebuild
	if use openmp; then
		if [[ $(tc-getCXX) =~ g++ ]]; then
			local eopenmp=-fopenmp
		elif [[ $(tc-getCXX) =~ cxx ]]; then
			local eopenmp=-openmp
			sed -e "s/-fopenmp/${eopenmp}/" -i Makefile || die
		else
			elog "Cannot detect compiler type so not setting openmp support"
		fi
	fi
}

src_compile(){
	mycmakeargs=(
		-DOPENMP="$(use_enable openmp)"
		-DHTSLIB_LOCAL=NO
	)
	cmake_src_compile
}
#
# src_install(){
# 	dobin bin/*
# 	dolib lib/* # install libvcflib.a
# 	dodoc README.md
# }
