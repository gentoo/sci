# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Fast LTL to Buechi Automata Translation"
HOMEPAGE="http://www.lsv.ens-cachan.fr/~gastin/${PN}/"
SRC_URI="http://www.lsv.ens-cachan.fr/~gastin/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_compile() {
	sed -i Makefile \
		-e "s/CC=gcc/#CC=gcc/g" \
		-e "s/CFLAGS= -O3 -ansi -DNXT/CFLAGS+= -ansi -DNXT/g"

	default
}

src_install() {
	dobin ltl2ba || die "dobin failed"
	dodoc README
}
