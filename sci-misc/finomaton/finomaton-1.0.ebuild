# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# N.B. this is from CTAN

DESCRIPTION="Simple tcl/tk script to draw finite state automata"
HOMEPAGE="https://www.ctan.org/pkg/finomaton"
SRC_URI="http://mirrors.ctan.org/graphics/finomaton.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

# script only
DEPEND=""
# tex for metapost
RDEPEND="
	dev-lang/tk:0
	dev-texlive/texlive-metapost"

S="${WORKDIR}"/${PN}

src_install() {
	dobin finomaton.tcl
	dodoc ChangeLog TODO README
	if use examples ; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
