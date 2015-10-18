# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="Bayesian gen. variant detector to find small polymorphisms: SNPs, indels, MNPs and complex events"
HOMEPAGE="https://github.com/ekg/freebayes"

if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="git://github.com/ekg/freebayes.git"
	EGIT_OPTIONS="--recursive --recurse-submodules"
	KEYWORDS=""
else
	EGIT_REPO_URI="git://github.com/ekg/freebayes.git"
	EGIT_OPTIONS="--recursive --recurse-submodules"
	EGIT_BRANCH="v0.9.21"
	KEYWORDS=""
fi

# To build freebayes you must use git to also download its submodules.
#   Do so by downloading freebayes again using this command (note --recursive flag):
#   git clone --recursive git://github.com/ekg/freebayes.git

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/bamtools
	sci-biology/samtools"

src_install(){
	dobin bin/freebayes bin/bamleftalign
	dobin vcflib/bin/*
}
