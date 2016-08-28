# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="VCF/BED utils, Genotype Phenotype Association Toolkit (GPAT++)"
HOMEPAGE="https://github.com/vcflib/vcflib"
EGIT_REPO_URI="https://github.com/vcflib/vcflib.git"

# vcflib is incorporated into several projects, such as freebayes

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS=""
IUSE="mpi"

DEPEND="mpi? ( sys-cluster/openmpi )"
RDEPEND="${DEPEND}"
# contains bundled sci-biology/htslib ?
# see also ./include for possible traces of other bundled sw

src_prepare(){
	default
	sed -e "s/^CXX = g++/CXX = $(tc-getCXX)/" -i Makefile || die
	sed -e "s/^CXXFLAGS = -O3/CXXFLAGS = ${CXXFLAGS}/" -i Makefile || die
}

src_compile(){
	if use mpi ; then
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
