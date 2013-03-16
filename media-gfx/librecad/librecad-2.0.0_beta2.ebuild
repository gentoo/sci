# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 eutils flag-o-matic

DESCRIPTION="An generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
SRC_URI="https://github.com/LibreCAD/LibreCAD/archive/2.0.0beta2.tar.gz ->
${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

DEPEND="
	dev-qt/qthelp:4
	dev-qt/qtgui:4
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
	sed -i -e '/RS_VECTOR2D/ s/^#//' librecad/src/src.pro
}

src_install() {
	dobin unix/librecad
	insinto /usr/share/"${PN}"
	doins -r unix/resources/*
	if use doc ; then
		dohtml -r support/doc/*
	fi
	doicon librecad/res/main/"${PN}".png
	make_desktop_entry "${PN}" LibreCAD "${PN}.png" Graphics
}
