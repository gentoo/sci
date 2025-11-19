# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="VCF/BED utils, Genotype Phenotype Association Toolkit (GPAT++)"
HOMEPAGE="https://github.com/vcflib/vcflib"
SRC_URI="https://github.com/vcflib/vcflib/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
# No proper release tarball for this release yet
KEYWORDS=""
IUSE="openmp"

DEPEND="
	virtual/zlib:=
	sci-libs/htslib
	sci-biology/tabixpp
"
RDEPEND="${DEPEND}"

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
		-DHTSLIB_LOCAL=ON
	)
	cmake_src_compile
}
#
# src_install(){
# 	dobin bin/*
# 	dolib lib/* # install libvcflib.a
# 	dodoc README.md
# }
