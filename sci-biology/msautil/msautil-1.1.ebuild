# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Reformat/edit FASTA files and compute simple statistics (N50, quartiles, mode)"
HOMEPAGE="http://bioresearch.byu.edu/msa"
SRC_URI="http://bioresearch.byu.edu/msa/${P}.tgz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	for f in fac.mak fas.mak mscore.mak; do sed -e "s/OPT = -O3/OPT = ${CFLAGS}/" -i $f || die; done
}

src_install(){
	dobin fac fas mscore
	dodoc README.txt
}
