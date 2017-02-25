# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="library for processing UTF-8 encoded Unicode strings"
HOMEPAGE="http://www.public-software-group.org/utf8proc"
SRC_URI="https://github.com/JuliaLang/${PN}/archive/v1.2.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-buildflags.patch
}

src_compile() {
	emake \
		libutf8proc.so \
		$(usex static-libs libutf8proc.a "") \
		CC=$(tc-getCC) \
		AR=$(tc-getAR)
#		CFLAGS="${CFLAGS}"
#		LDFLAGS="${LDFLAGS} -Wl,--soname,lib${PN}.${PV}"
}

src_install() {
	doheader utf8proc.h
	dolib.so libutf8proc.so*
	use static-libs && dolib.a libutf8proc.a
}
