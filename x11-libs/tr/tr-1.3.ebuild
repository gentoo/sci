# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="An OpenGL utility library for doing tiled rendering"
HOMEPAGE="http://www.mesa3d.org/brianp/TR.html"
SRC_URI="http://www.mesa3d.org/brianp/tr-1.3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/freeglut"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PV}-Makefile.patch )

src_prepare() {
	default
	tc-export CC
}

src_install() {
	doheader tr.h
	dobin trdemo{1,2}
	dodoc README
	docinto html
	dodoc tr.htm
}
