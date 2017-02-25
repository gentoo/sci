# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

[ "$PV" == "9999" ] && inherit git-r3

DESCRIPTION="NGS reads corrector"
HOMEPAGE="https://github.com/mourisl/Lighter"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/mourisl/Lighter.git"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="threads"

DEPEND="sys-libs/zlib
	sci-libs/bloom"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s#g++#$(tc-getCC)#;s#-Wall -O3#${CXXFLAGS}#" -i Makefile || die
}

src_install(){
	dobin lighter
	dodoc README.md
}
