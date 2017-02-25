# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Rapid reconstruction of phylogenies by the Neighbor-Joining method"
HOMEPAGE="http://www.sanger.ac.uk/Software/analysis/quicktree/"
SRC_URI="ftp://ftp.sanger.ac.uk/pub4/resources/software/${PN}/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="GRL"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${PN}_${PV}

src_prepare() {
	sed \
		-e "s/\-O2 \-Wall/${CFLAGS}/" \
		-i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" LFLAGS="${LDFLAGS}"
}

src_install() {
	dobin bin/quicktree
	dodoc README
}
