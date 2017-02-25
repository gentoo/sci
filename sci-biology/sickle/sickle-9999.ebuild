# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils eutils toolchain-funcs

[ "$PV" == "9999" ] && inherit git-r3

DESCRIPTION="Windowed adaptive quality-based trimming tool for FASTQ data"
HOMEPAGE="https://github.com/najoshi/sickle"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/najoshi/sickle"
	KEYWORDS=""
else
	SRC_URI="https://github.com/najoshi/sickle/archive/v"${PV}".tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-libs/zlib"

src_prepare(){
	sed -e "s#-pedantic#-pedantic ${CFLAGS}#;s#gcc#"$(tc-getCC)"#" -i Makefile || die
}

src_install(){
	dobin sickle
	dodoc README.md
}
