# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils

DESCRIPTION="Error correction for Illumina RNA-seq reads"
HOMEPAGE="https://github.com/mourisl/Rcorrector"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mourisl/Rcorrector.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=sci-biology/jellyfish-2.1.3:2"
RDEPEND="${DEPEND}
	dev-lang/perl"

src_prepare(){
	default
	epatch "${FILESDIR}"/Rcorrector-rename-jellyfish.patch
	# prevent building of jellyfish from bundled sources
	mkdir -p ./jellyfish/bin/ || die
	touch ./jellyfish/bin/jellyfish2 || die
	sed -e "s#-Wall -O3#${CXXFLAGS}#" -i Makefile || die
}

src_install(){
	dobin rcorrector run_rcorrector.pl
}

pkg_postinst(){
	einfo "Note that the default kmer size 23 is suboptimal, use k=31 instead"
}
