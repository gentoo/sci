# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/wxmacmolplt/wxmacmolplt-7.3.ebuild,v 1.1 2009/11/01 14:34:22 alexxy Exp $

EAPI="2"

inherit base eutils

DESCRIPTION="Simple job manager for GAMESS-US"
HOMEPAGE="http://www.msg.chem.iastate.edu/GAMESS/GamessQ/"

SRC_URI="http://www.msg.chem.iastate.edu/GAMESS/GamessQ/download/${P}.tar.gz"
LICENSE="GPL-3"

KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""

DEPEND="x11-libs/wxGTK"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	doicon src/icons/${PN}.ico
	make_desktop_entry ${PN} gamessq ${PN}.ico "Science;Education"
}
