# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="C/C++ library for working with human genetic variation data"
HOMEPAGE="http://atgu.mgh.harvard.edu/plinkseq"
SRC_URI="http://psychgen.u.hpc.mssm.edu/plinkseq_downloads/plinkseq-src-latest.tgz -> ${P}.tgz"
# https://bitbucket.org/statgen/plinkseq.git
# http://pngu.mgh.harvard.edu/~purcell/plink/download.shtml

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s/gcc/$(tc-getCC)/g;s/g++/$(tc-getCXX)/g;s/-O3/${CFLAGS}/g" -i config_defs.Makefile || die
	sed -e "s/= -static/=/g" -i config_defs.Makefile || die
}

src_install(){
	cd build/execs || die
	# TODO: avoid file collision with sci-biology/fsl
	# https://bitbucket.org/statgen/plinkseq/issue/9/rename-mm-filename-to-plinkseq_mm
	dobin gcol browser pseq behead mm smp tab2vcf mongoose pdas
}
