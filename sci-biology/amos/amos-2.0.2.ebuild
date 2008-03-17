# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3

DESCRIPTION="A Modular, Open-Source whole genome assembler"
HOMEPAGE="http://amos.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND="$(qt_min_version 3.3)"
RDEPEND="${DEPEND}
	sci-biology/mummer"

src_compile() {
	econf || die "econf failed"
	# TODO: fix parallel make. Notified upstream
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
