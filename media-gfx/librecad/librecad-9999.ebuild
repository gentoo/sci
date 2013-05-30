# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit qt4-r2 eutils git-2 flag-o-matic

DESCRIPTION="An generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

EGIT_REPO_URI="https://github.com/LibreCAD/LibreCAD.git"

DEPEND="${RDEPEND}
	dev-qt/qtgui:4
	dev-qt/qthelp:4
	dev-qt/qtsvg:4
	dev-libs/boost
	dev-cpp/muParser
	media-libs/freetype
"

src_prepare() {
	#sed -i -e "s:\\\$\+system(git describe --tags):9999:" src/src.pro
	#enable C++11 by default
	sed -i -e '/RS_VECTOR2D/ s/^#//' librecad/src/src.pro
}

src_install()
{
	dobin unix/librecad
	insinto /usr/share/"${PN}"
	doins -r unix/resources/*
	if use doc ; then
	dohtml -r support/doc/*
	fi
	doicon librecad/res/main/"${PN}".png
	make_desktop_entry "${PN}" LibreCAD "${PN}" Graphics
}
