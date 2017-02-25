# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Micro Read Fast Alignment Search Tool"
HOMEPAGE="http://mrfast.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

src_prepare() {
	sed \
		-e '/^CC/s:=:?=:g' \
		-e 's/CFLAGS =/CFLAGS +=/' \
		-e 's/LDFLAGS/LIBS/g' \
		-e 's:-O3.*::g' \
		-e 's:$(CC) $(OBJECTS):$(CC) $(LDFLAGS) $(OBJECTS):g' \
		-i Makefile || die
	tc-export CC
}

src_install() {
	dobin ${PN}
}
