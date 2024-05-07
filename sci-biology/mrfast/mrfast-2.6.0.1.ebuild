# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Micro Read Fast Alignment Search Tool"
HOMEPAGE="http://mrfast.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	default
	sed \
		-e '/^CC/s:=:?=:g' \
		-e 's/CFLAGS =/CFLAGS +=/' \
		-e 's/LDFLAGS/LIBS/g' \
		-e 's:-O3.*::g' \
		-e 's:$(CC) $(OBJECTS):$(CC) $(LDFLAGS) $(OBJECTS):g' \
		-i Makefile || die
}

src_configure() {
	tc-export CC
	append-cflags -fcommon
	default
}

src_install() {
	dobin ${PN}
}
