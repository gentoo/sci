# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Error correction for Illumina RNA-seq reads"
HOMEPAGE="https://github.com/mourisl/Rcorrector"
SRC_URI="https://github.com/mourisl/Rcorrector/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-biology/jellyfish-2.1.3:2"
RDEPEND="${DEPEND}
	dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/Rcorrector-rename-jellyfish.patch
)

src_prepare(){
	default
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
