# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Rapid reconstruction of phylogenies by the Neighbor-Joining method"
HOMEPAGE="https://github.com/khowe/quicktree/"
SRC_URI="https://github.com/khowe/quicktree/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#S=${WORKDIR}/${PN}_${PV}

src_prepare() {
	default
	sed -e "s/\-O2/${CFLAGS}/" \
	    -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" LFLAGS="${LDFLAGS}"
}

src_install() {
	dobin quicktree
	einstalldocs
}
