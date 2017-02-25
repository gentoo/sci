# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

[ "$PV" == "9999" ] && inherit git-r3

DESCRIPTION="C++ Bloom Filter Library"
HOMEPAGE="https://github.com/arashpartow/bloom"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/ArashPartow/bloom.git"
else
	SRC_URI=""
fi

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s#-c++#$(tc-getCXX)#;s#-O3#${CXXFLAGS}#" -i Makefile || die
	sed -e "s#-pedantic-errors -ansi -Wall -Wextra -Werror -Wno-long-long##" -i Makefile || die
}
