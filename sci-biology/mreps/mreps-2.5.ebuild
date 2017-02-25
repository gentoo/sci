# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Identification of serial/tandem repeats in DNA sequences"
HOMEPAGE="http://bioinfo.lifl.fr/mreps/"
SRC_URI="http://bioinfo.lifl.fr/mreps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed \
		-e 's/CC\s*=\s*gcc/CC := ${CC} ${CFLAGS}/' \
		-e 's:-O3::g' \
		-i "${S}"/Makefile || die
	tc-export CC
}

src_install() {
	dobin mreps
}
