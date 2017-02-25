# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Reformat/edit FASTA files and compute simple statistics (N50, quartiles, mode)"
HOMEPAGE="http://bioresearch.byu.edu/msa"
SRC_URI="http://bioresearch.byu.edu/msa/${P}.tgz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare(){
	sed \
		-e "s/OPT = -O3/OPT = ${CFLAGS}/" \
		-i fac.mak fas.mak mscore.mak || die
	tc-export CC
	default
}

src_install(){
	dobin fac fas mscore
	dodoc README.txt
}
