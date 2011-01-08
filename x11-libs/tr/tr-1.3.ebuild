# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="An OpenGL utility library for doing tiled rendering"
HOMEPAGE="http://www.mesa3d.org/brianp/TR.html"
SRC_URI="http://www.mesa3d.org/brianp/tr-1.3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/freeglut"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-Makefile.patch
}

src_install() {
	insinto /usr/include/
	doins tr.h || die
	dobin trdemo{1,2} || die
	dodoc README || die
	dohtml tr.htm || die
}
