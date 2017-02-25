# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Scripts to run genome assembly scaffolding tools and analyse output for accuracy"
HOMEPAGE="https://github.com/martinghunt/Scaffolder-evaluation
	http://genomebiology.com/2014/15/3/R42"
EGIT_REPO_URI="https://github.com/martinghunt/Scaffolder-evaluation.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	dev-lang/python
	dev-lang/R
	media-gfx/graphviz
	sci-biology/mummer
	sci-biology/bowtie
	sci-biology/samtools
	sci-biology/ncbi-tools
	sci-biology/Fastaq"

src_install(){
	dobin Analysis-scripts/* Wrapper-scripts/*
	dodoc README.md
}
