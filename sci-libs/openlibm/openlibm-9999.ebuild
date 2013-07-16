# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://github.com/JuliaLang/openlibm.git"

inherit git-2 eutils fortran-2

DESCRIPTION="High quality system independent, open source libm"
HOMEPAGE="http://julialang.org/"
SRC_URI=""

LICENSE="MIT freedist public-domain BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-respect-toolchain.patch \
		"${FILESDIR}"/${PN}-soname.patch \
		"${FILESDIR}"/${PN}-extras-soname.patch
}

src_compile() {
	emake libopenlibm.so
	use static-libs && emake libopenlibm.a
	emake -f Makefile.extras libopenlibm-extras.so
	use static-libs && emake -f Makefile.extras libopenlibm-extras.a
}

src_test() {
	emake
}

src_install() {
	dolib.so libopenlibm.so
	dolib.so libopenlibm-extras.so
	use static-libs && dolib.a libopenlibm.a
	use static-libs && dolib.so liboenlibm-extras.a
	doheader include/{cdefs,types}-compat.h src/openlibm.h
	dodoc README.md
}
