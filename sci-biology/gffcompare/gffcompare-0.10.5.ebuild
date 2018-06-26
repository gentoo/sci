# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Compare, classify, merge, track, annotate GFF files"
HOMEPAGE="http://ccb.jhu.edu/software/stringtie/gff.shtml
	https://github.com/gpertea/gffcompare"
SRC_URI="https://github.com/gpertea/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gpertea/gclib/archive/v0.10.2.tar.gz -> gclib-0.10.2.tar.gz"

LICENSE="MIT Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# this cannot just depend on sci-biology/gclib (headers), the code inside
# gclib needs to be compiled and objects get included inside gffcompare
DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/Makefile.patch )

src_compile(){
	GCLIB=../gclib-0.10.2 emake
}

src_install(){
	dobin gffcompare
	dodoc README.md
}
