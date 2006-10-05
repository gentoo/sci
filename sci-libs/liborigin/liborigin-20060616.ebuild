# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Library for reading Origin spreadshits"
HOMEPAGE="http://sourceforge.net/projects/liborigin/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
SRC_URI="mirror://sourceforge/liborigin/${P}.tar.gz"

#### Remove the next line when moving this ebuild to the main tree!
RESTRICT="nomirror"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/Makefile.patch"
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" -f Makefile.LINUX || die "emake failed"
}

src_install() {
	dobin opj2dat
	dolib liborigin.so
	dodoc README
}
