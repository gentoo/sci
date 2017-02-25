# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Intrinsic Protein Disorder Prediction"
HOMEPAGE="http://dis.embl.de"
SRC_URI="http://dis.embl.de/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# The smoothing function sav_gol.c cannot be re-distributed but can be downloaded from TISEAN.
# http://www.mpipks-dresden.mpg.de/~tisean/

DEPEND="sci-mathematics/tisean"
RDEPEND="${DEPEND}
	sci-biology/biopython"

src_prepare(){
	sed -e 's@/usr/local/bin/@ /usr/bin/env @' -i DisEMBL.py || die
}

src_compile(){
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} disembl.c -o disembl
}

src_install(){
	dobin DisEMBL.py disembl
	dodoc INSTALL CHANGELOG
}
