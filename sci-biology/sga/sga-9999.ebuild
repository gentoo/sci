# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 autotools

DESCRIPTION="String Graph OLC Assembler for short reads (overlap-layout-consensus)"
HOMEPAGE="https://github.com/jts/sga"
EGIT_REPO_URI="https://github.com/jts/sga"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="jemalloc python"

DEPEND="
	dev-cpp/sparsehash
	sci-biology/bamtools
	virtual/zlib:=
	jemalloc? ( dev-libs/jemalloc )
"
RDEPEND="${DEPEND}
	sci-biology/abyss
	python? ( sci-biology/pysam
			sci-biology/ruffus )"

S="${WORKDIR}/${P}/src"

src_prepare() {
	default
	eautoreconf
}

# http://www.vcru.wisc.edu/simonlab/bioinformatics/programs/install/sga.htm
src_configure(){
	econf --with-bamtools="${EPREFIX}"/usr --with-sparsehash="${EPREFIX}"/usr
}

src_compile(){
	# https://github.com/AlgoLab/FastStringGraph/issues/1#issuecomment-345999596
	# https://github.com/jts/sga/issues/106
	# https://github.com/jts/sga/pull/110
	# https://github.com/jts/sga/issues/108
	#
	# other unreviewed patches:
	# https://github.com/jts/sga/issues/96
	default
}

src_install(){
	dodoc README
	emake install DESTDIR="${D}"
	insinto /usr/share/sga/examples
	doins -r examples/*
	cd .. ||
	dodoc README.md
}
