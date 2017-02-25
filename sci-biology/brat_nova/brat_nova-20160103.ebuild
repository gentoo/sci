# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Bisulfite-aware short read mapper, FM-index, accepts 1 InDel/read, local align"
HOMEPAGE="http://compbio.cs.ucr.edu/brat/"
SRC_URI="http://compbio.cs.ucr.edu/brat/downloads/brat_nova.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="!sci-biology/brat
	!sci-biology/brat_bw"

S="${WORKDIR}"/"${PN}"

src_prepare() {
	sed \
		-e "s:g++:$(tc-getCXX):g" \
		-e "s:-O3 -w:${CFLAGS} ${LDFLAGS}:g" \
		-i Makefile || die
}

src_install() {
	dobin brat_bw build_bw trim acgt-count remove-dupl
	# possible FILE_COLLISION
	# on these with with sci-biology/brat
		# trim acgt-count remove-dupl
	# on these with sci-biology/brat_bw
		# brat_bw build_bw trim acgt-count remove-dupl
}
