# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Bisulfite-treated Reads Analysis Tool (short read mapper)"
HOMEPAGE="http://compbio.cs.ucr.edu/brat/"
SRC_URI="http://compbio.cs.ucr.edu/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_prepare() {
	sed \
		-e "s:g++:$(tc-getCXX):g" \
		-e "s:-O3:${CFLAGS} ${LDFLAGS}:g" \
		-e "s:-w:-Wall:g" \
		-i Makefile || die
}

src_test() {
	cd test_quick_start || die
	ebegin "unpacking test files"
	tar xzf test_data.tgz || die
	eend $?

	../brat -r references.txt -1 test_reads1.txt -2 test_reads2.txt -o output.txt -bs -pe -i 200 -a 300 || die
	../brat -r references.txt -s test_reads1.txt -o output_singles1.txt -bs || die
	../brat -r references.txt -s test_reads2.txt -o output_singles2.txt -bs -A || die
}

src_install() {
	dobin ${PN} ${PN}-large trim acgt-count ${PN}-large-build rev-compl check-strands remove-dupl convert-to-sam
	dodoc BRAT_USER_MANUAL_*.pdf
}
