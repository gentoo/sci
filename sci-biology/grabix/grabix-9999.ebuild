# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="Provide random access to text files BGZF compressed with bgzip"
HOMEPAGE="https://github.com/arq5x/grabix"
EGIT_REPO_URI="https://github.com/arq5x/grabix.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile(){
	"$(tc-getCC)" ${CFLAGS} -o grabix grabix_main.cpp grabix.cpp bgzf.c -lstdc++ -lz || die
}

src_install(){
	dobin grabix
	dodoc README.md
}
