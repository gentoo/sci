# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# N.B. this is from CTAN

DESCRIPTION="Simple tcl/tk script to draw finite state automata"
HOMEPAGE="http://stud4.tuwien.ac.at/~e0225855/finomaton/finomaton.html"
SRC_URI="http://stud4.tuwien.ac.at/~e0225855/finomaton/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

# script only
DEPEND=""
# tex for metapost
RDEPEND="
	dev-lang/tk
	dev-texlive/texlive-metapost"

src_install() {
	dobin finomaton.tcl
	dodoc ChangeLog TODO README
	if use examples ; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
