# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 eutils fortran-2

DESCRIPTION="High quality system independent, open source libm"
HOMEPAGE="http://julialang.org/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/JuliaLang/openlibm.git"

LICENSE="public-domain MIT ISC BSD-2 LGPL-2.1+"
SLOT="0"
KEYWORDS=""

IUSE="static-libs"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-respect-toolchain.patch
}

src_compile() {
	emake libopenlibm.so
	use static-libs && emake libopenlibm.a
}

src_test() {
	default
}

src_install() {
	dolib.so libopenlibm.so*
	use static-libs && dolib.a libopenlibm.a
	doheader include/{cdefs,types}-compat.h src/openlibm.h
	dodoc README.md
}
