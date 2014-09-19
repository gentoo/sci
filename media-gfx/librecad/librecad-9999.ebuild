# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2 eutils git-r3

DESCRIPTION="Generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/LibreCAD/LibreCAD.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc"

DEPEND="${RDEPEND}
	dev-qt/qtgui:4
	dev-qt/qthelp:4
	dev-qt/qtsvg:4
	dev-libs/boost
	dev-cpp/muParser
	media-libs/freetype"

src_prepare() {
	#sed -i -e "s:\\\$\+system(git describe --tags):9999:" src/src.pro
	#enable C++11 by default
	sed -i -e '/RS_VECTOR2D/ s/^#//' librecad/src/src.pro || die
}

src_install() {
	dobin unix/librecad
	insinto /usr/share
	doins -r unix/appdata
	insinto /usr/share/${PN}
	doins -r unix/resources/*
	use doc && dohtml -r librecad/support/doc/*
	doicon librecad/res/main/${PN}.png
	make_desktop_entry ${PN} LibreCAD ${PN} Graphics
}
