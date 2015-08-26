# Copyright 1999-2014 Gentoo Foundation
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
RDEPEND="
	dev-cpp/eigen:3
	dev-qt/qtcore
	dev-qt/qtsvg
	dev-qt/qtgui
	dev-qt/qtwebkit
	dev-qt/qtopengl
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare()
{
	sed -i -e 's|../eigen|/usr/include/eigen3|' \
		-e 's|shell hg|shell true|g' Clip4.pro || die "sed failed"
}

src_install()
{
	dobin Clip
	dodoc README.txt
}
