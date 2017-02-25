# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Bisulfite-aware short read mapper, FM-index, no InDel support"
HOMEPAGE="http://compbio.cs.ucr.edu/brat/"
SRC_URI="http://compbio.cs.ucr.edu/brat/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="!sci-biology/brat"

src_prepare() {
	sed \
		-e "s:-Wl,-O1 : :g" \
		-e "s:g++:$(tc-getCXX):g" \
		-e "s:-O3:${CFLAGS} ${LDFLAGS}:g" \
		-e "s:-w:-Wall:g" \
		-i Makefile || die
}

src_install() {
	dobin brat_bw build_bw trim acgt-count remove-dupl convert_to_sam
	# possible FILLE_COLLISION with sci-biology/brat (probably some binaries just do the same)
	# dobin ${PN} ${PN}-large trim acgt-count ${PN}-large-build rev-compl check-strands remove-dupl convert-to-sam
	dodoc README
	newdoc {'User Manual BRAT_2_0_1.pdf','User_Manual_BRAT_2_0_1.pdf'}
}
