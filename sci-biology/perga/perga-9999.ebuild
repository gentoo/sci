# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic git-r3 toolchain-funcs

DESCRIPTION="Paired End Reads Guided Assembler"
HOMEPAGE="https://github.com/hitbio/PERGA
	http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4252104"
EGIT_REPO_URI="https://github.com/hitbio/PERGA.git"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	default
	# needed for newer gcc versions
	append-cflags -Wl,--unresolved-symbols=ignore-in-object-files
	sed -e "s/gcc -g /$(tc-getCC) ${CFLAGS} ${LDFLAGS} /" -i src/Makefile || die
	sed -e 's/-Wl,-O1//' -i src/Makefile || die
}

src_compile(){
	cd src || die
	emake
}

src_install(){
	dobin src/perga
	einstalldocs
}
