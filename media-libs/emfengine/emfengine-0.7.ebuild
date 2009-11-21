# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4

MY_PN="EmfEngine"

DESCRIPTION="Native vector graphics file format on Windows"
HOMEPAGE="http://soft.proindependent.com/emf/index.html"
SRC_URI="mirror://berlios/qtiplot/${MY_PN}-${PV}-opensource.zip"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
IUSE=""

RDEPEND="
	x11-libs/qt-gui
	media-libs/libpng
	media-libs/libemf"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"/${MY_PN}

PATCHES=(
	"${FILESDIR}/${PV}-config.patch"
	"${FILESDIR}/${PV}-header.patch"
	)

src_compile() {
	eqmake4 ${MY_PN}.pro
	emake sub-src-make_default || die
}

src_install() {
	dolib.so libEmfEngine.so* || die
	insinto /usr/include
	doins src/*.h || die
}
