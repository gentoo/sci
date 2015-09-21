# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2 versionator

MY_P="Clip4_$(get_version_component_range 4)_source"

DESCRIPTION="Interactive program for evaluation of Laue diffraction patterns"
HOMEPAGE="http://clip4.sf.net/"
SRC_URI="mirror://sourceforge/clip4/${MY_P}.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-cpp/eigen:3
	dev-qt/qtcore:4=
	dev-qt/qtsvg:4=
	dev-qt/qtgui:4=
	dev-qt/qtwebkit:4=
	dev-qt/qtopengl:4=
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare(){
	sed -i -e 's|../eigen|/usr/include/eigen3|' \
		-e 's|shell hg|shell true|g' Clip4.pro || die "sed failed"
}

src_install(){
	dobin Clip
	dodoc README.txt
}
