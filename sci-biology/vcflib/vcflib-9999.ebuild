# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="VCF/BED utils, Genotype Phenotype Association Toolkit (GPAT++)"
HOMEPAGE="https://github.com/vcflib/vcflib"
EGIT_REPO_URI="https://github.com/vcflib/vcflib.git"

# vcflib is incorporated into several projects, such as freebayes

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS=""
IUSE="openmp"

DEPEND=""
RDEPEND="${DEPEND}"
# contains bundled sci-biology/htslib ?
# see also ./include for possible traces of other bundled sw

src_prepare(){
	default
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
	if use openmp ; then
		emake openmp
	else
		emake
	fi
}

src_install(){
	dobin bin/*
	dolib lib/* # install libvcflib.a
	dodoc README.md
}
