# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit qt4-r2 git-2

DESCRIPTION="An generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

EGIT_REPO_URI="https://github.com/LibreCAD/LibreCAD.git"

RDEPEND="x11-libs/qt-gui[qt3support]"
DEPEND="${RDEPEND}
	x11-libs/qt-assistant:4
	x11-libs/qt-qt3support:4
"
src_prepare()
{
	# patch to solve an issue caused by gcc-4.6, by mickele, archlinux
	sed -e "s|LiteralMask<Value_t, n>::mask;|LiteralMask<Value_t, static_cast<unsigned int>(n)>::mask;|" \
	-e "s|SimpleSpaceMask<n>::mask;|SimpleSpaceMask<static_cast<unsigned int>(n)>::mask;|" \
	-i fparser/fparser.cc
}

src_install()
{
	dobin unix/librecad
	insinto /usr/share/"${PN}"
	doins -r unix/resources/*
	if use doc ; then
	dohtml -r support/doc/*
	fi
	doicon res/main/"${PN}".png
	make_desktop_entry "${PN}" LibreCAD "${PN}.png" Graphics
}
