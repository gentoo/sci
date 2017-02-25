# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Micro Read Fast Alignment Search Tool"
HOMEPAGE="http://mrsfast.sourceforge.net/Home"
SRC_URI="mirror://sourceforge/mrsfast/${PV}/${P}.zip"

LICENSE="BSD"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

src_prepare() {
	sed \
		-e "s:gcc:$(tc-getCC) ${LDFLAGS}:g" \
		-e '/^CFLAGS/d' \
		-e '/^LDFLAGS/d' \
		-i Makefile || die
	tc-export CC
}

src_install() {
	dobin ${PN}
}
