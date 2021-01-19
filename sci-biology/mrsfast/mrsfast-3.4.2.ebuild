# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Micro Read Fast Alignment Search Tool"
HOMEPAGE="https://sfu-compbio.github.io/mrsfast/"
SRC_URI="https://github.com/sfu-compbio/mrsfast/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

src_prepare() {
	default
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
