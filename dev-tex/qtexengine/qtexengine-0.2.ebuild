# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4

MY_PN="QTeXEngine"

DESCRIPTION="Enables Qt based applications to easily export graphics to TeX"
HOMEPAGE="http://soft.proindependent.com/${PN}"
SRC_URI="mirror://berlios/qtiplot/${MY_PN}-${PV}-opensource.zip"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
IUSE=""

RDEPEND="x11-libs/qt-gui"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"/${MY_PN}

PATCHES=(
	"${FILESDIR}/${PV}-interpolate.patch"
	"${FILESDIR}/${PV}-dynlib.patch"
	)

src_compile() {
	eqmake4 QTeXEngine.pro
	emake sub-src-all || die
}

src_install() {
	dolib.so lib${MY_PN}.so* || die
	insinto /usr/include
	doins src/${MY_PN}.h || die
	dodoc CHANGES.txt || die
	dohtml -r ./doc/html/* || die
}
