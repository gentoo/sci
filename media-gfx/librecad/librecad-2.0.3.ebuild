# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2 eutils flag-o-matic

DESCRIPTION="Generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
SRC_URI="https://github.com/LibreCAD/LibreCAD/archive/${PV/_/}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc 3d"

DEPEND="
	dev-qt/qtgui:4
	dev-qt/qthelp:4
	dev-qt/qtsvg:4
	dev-libs/boost
	dev-cpp/muParser
	media-libs/freetype
	"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv * ${P}
}

src_prepare() {
	# currently RS_VECTOR3D causes an internal compiler error on GCC-4.8
	use 3d || sed -i -e '/RS_VECTOR2D/ s/^#//' librecad/src/src.pro
}

src_install() {
	dobin unix/librecad
	insinto /usr/share/${PN}
	doins -r unix/resources/*
	use doc && dohtml -r support/doc/*
	doicon librecad/res/main/${PN}.png
	make_desktop_entry ${PN} LibreCAD ${PN} Graphics
}
