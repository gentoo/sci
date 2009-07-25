# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base eutils

DESCRIPTION="Chemical 3D graphics program with GAMESS input builder"
HOMEPAGE="http://www.scl.ameslab.gov/~brett/MacMolPlt/"

SRC_URI="http://www.scl.ameslab.gov/~brett/MacMolPlt/download/${P}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="flash"

DEPEND="x11-libs/wxGTK[opengl]
		flash? ( media-libs/ming )"

RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with flash ming)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	doicon resources/${PN}.png
	make_desktop_entry ${PN} wxMacMolPlt ${PN}.png "Science;Education"
}
