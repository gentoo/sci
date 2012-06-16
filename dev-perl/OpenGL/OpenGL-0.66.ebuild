# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MODULE_AUTHOR="CHM"

inherit perl-module eutils

DESCRIPTION="Perl interface providing graphics display using OpenGL"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/freeglut
	x11-libs/libICE
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu"
DEPEND="${RDEPEND}"

mydoc="Release_Notes"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-display.patch
}

src_compile() {
	sed -i -e 's/PERL_DL_NONLAZY=1//' Makefile || die
	perl-module_src_compile
}
