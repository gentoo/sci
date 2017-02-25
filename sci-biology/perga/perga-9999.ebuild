# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 eutils toolchain-funcs

DESCRIPTION="Paired End Reads Guided Assembler"
HOMEPAGE="https://github.com/hitbio/PERGA
	http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4252104"
EGIT_REPO_URI="https://github.com/hitbio/PERGA.git"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s/gcc -g /$(tc-getCC) ${CFLAGS} ${LDFLAGS} /" -i src/Makefile || die
	sed -e 's/-Wl,-O1//' -i src/Makefile || die
}

# does not compile with gcc-5.3.0 but 4.9.3 works
src_compile(){
	cd src || die
	emake
}

src_install(){
	dobin src/perga
	dodoc README
}
