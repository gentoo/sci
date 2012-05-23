# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 eutils flag-o-matic

DESCRIPTION="An generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
SRC_URI="https://nodeload.github.com/LibreCAD/LibreCAD/tarball/${PV/_/} ->
${P}.tar.gz"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

DEPEND="
	x11-libs/qt-assistant:4
	x11-libs/qt-gui:4
	dev-libs/boost
	dev-cpp/muParser
	"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv * ${P}
}

src_prepare() {
	append-cppflags "-std=c++0x"
    sed -i -e '/RS_VECTOR2D/ s/^#//' librecad/src/src.pro
}

src_install() {
	qt4-r2 eutils_src_install
	dobin unix/librecad
	insinto /usr/share/"${PN}"
	doins -r unix/resources/*
	if use doc ; then
		dohtml -r support/doc/*
	fi
	doicon res/main/"${PN}".png
	make_desktop_entry "${PN}" LibreCAD "${PN}.png" Graphics
}
