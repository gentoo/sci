# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="The purpose of this library is to simplify the creation of computer graphics software"
HOMEPAGE="http://mgarland.org/software/libgfx.html"
SRC_URI="http://mgarland.org/dist/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gcc4.3.patch
}

src_compile() {
	cd src
	emake || die
}

src_install() {
	dolib.a src/*.a ||die
	insinto /usr/include/
	doins include/gfx/gfx.h || die

	dohtml doc/* || die
}
