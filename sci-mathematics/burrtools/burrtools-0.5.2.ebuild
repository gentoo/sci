# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Program to solve assembly and interlocking puzzles"
HOMEPAGE="http://burrtools.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/${P}-A4.pdf )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="doc examples"

DEPEND="x11-libs/fltk:1.1
	media-libs/libpng"
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/${P}-A4.pdf || die
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}
