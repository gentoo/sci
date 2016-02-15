# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils git-r3

DESCRIPTION="Bayesian gen. variant detector to find small polymorphisms"
HOMEPAGE="https://github.com/ekg/freebayes"
EGIT_REPO_URI="git://github.com/ekg/freebayes.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/bamtools
	sci-biology/samtools"

src_install(){
	dobin bin/freebayes bin/bamleftalign
	dobin vcflib/bin/*
}
