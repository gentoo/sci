# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Identification of serial/tandem repeats in DNA sequences"
HOMEPAGE="https://mreps.univ-mlv.fr/"
SRC_URI="https://github.com/gregorykucherov/mreps/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed \
		-e 's/CC\s*=\s*gcc/CC := ${CC} ${CFLAGS}/' \
		-e 's:-O3::g' \
		-i "${S}"/Makefile || die
	tc-export CC
}

src_install() {
	dobin mreps
}
