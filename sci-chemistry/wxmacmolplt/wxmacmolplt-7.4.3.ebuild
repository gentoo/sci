# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
WX_GTK_VER=2.8

inherit base eutils autotools wxwidgets

DESCRIPTION="Chemical 3D graphics program with GAMESS input builder"
HOMEPAGE="http://www.scl.ameslab.gov/MacMolPlt/"
SRC_URI="http://www.scl.ameslab.gov/MacMolPlt/download/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="flash"

RDEPEND="
	media-libs/glew
	media-libs/mesa
	x11-libs/wxGTK:2.8[X,opengl]
	flash? ( media-libs/ming )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-glew.patch
	sed -i -e "/^dist_doc_DATA/d" Makefile.am \
		|| die "Failed to disable installation of LICENSE file"
	eautoreconf
}

src_configure() {
	econf \
		--with-glew \
		$(use_with flash ming)
}

src_install() {
	default
	doicon resources/${PN}.png
	make_desktop_entry ${PN} wxMacMolPlt ${PN} "Science;DataVisualization;"
}
