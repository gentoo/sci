# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils git-r3

DESCRIPTION="String Graph OLC Assembler for short reads (overlap-layout-consensus)"
HOMEPAGE="https://github.com/jts/sga"
EGIT_REPO_URI="https://github.com/jts/sga"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="jemalloc python"

DEPEND="dev-cpp/sparsehash
	sci-biology/bamtools
	sys-libs/zlib
	jemalloc? ( dev-libs/jemalloc )"
RDEPEND="${DEPEND}
	sci-biology/abyss
	python? ( sci-biology/pysam
			sci-biology/ruffus )"

# http://www.vcru.wisc.edu/simonlab/bioinformatics/programs/install/sga.htm
src_configure(){
	cd src || die
	./autogen.sh || die
	econf --with-bamtools="${EPREFIX}"/usr
}

src_compile(){
	# https://github.com/AlgoLab/FastStringGraph/issues/1#issuecomment-345999596
	# https://github.com/jts/sga/issues/106
	# https://github.com/jts/sga/pull/110
	# https://github.com/jts/sga/issues/108
	#
	# other unreviewed patches:
	# https://github.com/jts/sga/issues/96
	cd src || die "Try -atd=g++-98, try gcc-5 or -std=c++03"
	default
}

src_install(){
	cd src || die
	dodoc README
	emake install DESTDIR="${D}"
	insinto /usr/share/sga/examples
	doins -r examples/*
	cd .. ||
	dodoc README.md
}
