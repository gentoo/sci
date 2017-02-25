# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Simplify the creation of computer graphics software"
HOMEPAGE="http://mgarland.org/software/libgfx.html"
SRC_URI="http://mgarland.org/dist/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

PATCHES=( "${FILESDIR}"/${PV}-gcc4.3.patch )

src_compile() {
	cd src || die
	default
}

src_install() {
	use static-libs && dolib.a src/*.a
	doheader include/gfx/gfx.h

	dohtml doc/*
}
