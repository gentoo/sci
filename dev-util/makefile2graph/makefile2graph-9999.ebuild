# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Create a graph of dependencies from GNU Make"
HOMEPAGE="https://github.com/lindenb/makefile2graph"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lindenb/makefile2graph"
else
	SRC_URI="https://github.com/lindenb/makefile2graph/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( media-gfx/graphviz )"

src_prepare(){
	sed -e "s|/usr/local|${EPREFIX}/usr|" -i Makefile || die
	default
}

src_compile() {
	CC="$(tc-getCC)" default
}

src_test() {
	CC="$(tc-getCC)" emake test
}
