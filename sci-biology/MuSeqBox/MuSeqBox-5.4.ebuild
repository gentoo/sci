# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Parse and filter BLAST output into tab-delimited file"
HOMEPAGE="http://brendelgroup.org/bioinformatics2go/MuSeqBox.php"
SRC_URI="http://www.brendelgroup.org/bioinformatics2go/Download/MuSeqBox-4-8-2015.tar.gz"
# code will move to https://github.com/BrendelGroup

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/MUSEQBOX5.4"

src_compile(){
	cd src || die
	$(tc-getCXX) ${CFLAGS} -DLINUX -c MuSeqBox.C || die
	$(tc-getCXX) ${CFLAGS} ${LDFLAGS} -DLINUX MuSeqBox.o -o ../bin/MuSeqBox || die
}

src_install(){
	dobin bin/*
	dodoc 0README
	insinto /usr/share/"${PN}"
	doins doc/*.ps doc/*.pdf
	doins -r data
	doman doc/MuSeqBox.1
}
