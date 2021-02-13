# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-r1 perl-functions git-r3

DESCRIPTION="Scripts to run genome assembly scaffolding tools and analyse output for accuracy"
HOMEPAGE="https://github.com/martinghunt/Scaffolder-evaluation
	https://genomebiology.biomedcentral.com/articles/10.1186/gb-2014-15-3-r42"
EGIT_REPO_URI="https://github.com/martinghunt/Scaffolder-evaluation.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-lang/perl
	dev-lang/R
	media-gfx/graphviz
	sci-biology/mummer
	sci-biology/bowtie
	sci-biology/samtools
	sci-biology/ncbi-tools
	sci-biology/Fastaq[${PYTHON_USEDEP}]
"

src_install(){
	python_foreach_impl python_doscript Analysis-scripts/*.py
	dobin Analysis-scripts/*.sh
	perl_domodule Wrapper-scripts/*
	dodoc README.md
}
