# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Compare, classify, merge, track, annotate GFF files"
HOMEPAGE="http://ccb.jhu.edu/software/stringtie/gff.shtml
	https://github.com/gpertea/gffcompare"
SRC_URI="https://github.com/gpertea/gffcompare/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"

src_install(){
	dobin gffcompare
	dodoc README.md
}
