# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qt4-r2 vcs-snapshot

DESCRIPTION="An generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
SRC_URI="https://github.com/LibreCAD/LibreCAD/archive/v1.0.3.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="
	dev-qt/qtgui[qt3support]
	dev-qt/qthelp:4
	dev-qt/qt3support:4
	dev-cpp/muParser"

DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s:\\\$\+system(git describe --tags):1.0.3:" "${PN}.pro" || die
}

src_install() {
	dobin unix/librecad
	insinto /usr/share/"${PN}"
	doins -r unix/resources/*
	use doc && dohtml -r support/doc/*
	doicon res/main/"${PN}".png
	make_desktop_entry "${PN}" LibreCAD "${PN}.png" Graphics
}
