# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="GRAPPA20"

DESCRIPTION="Genome Rearrangements Analysis under Parsimony and other Phylogenetic Algorithms"
HOMEPAGE="https://www.cs.unm.edu/~moret/GRAPPA/"
SRC_URI="https://www.cs.unm.edu/~moret/GRAPPA/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i -e '/CFLAGS := -mcpu/ d' -e 's/\(CFLAGS := -D${OS}\)/\1 ${CFLAGS}/' "${S}/Makefile" || die
}

src_install() {
	dobin grappa
	dosym grappa /usr/bin/invdist
	# avoid file collision with emboss and rename distmat to distmat_grappa
	dosym grappa /usr/bin/distmat_grappa
	dodoc README
}
