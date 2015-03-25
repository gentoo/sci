# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_P="GRAPPA20"

DESCRIPTION="Genome Rearrangements Analysis under Parsimony and other Phylogenetic Algorithms"
HOMEPAGE="http://www.cs.unm.edu/~moret/GRAPPA/"
SRC_URI="http://www.cs.unm.edu/~moret/GRAPPA/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e '/CFLAGS := -mcpu/ d' -e 's/\(CFLAGS := -D${OS}\)/\1 ${CFLAGS}/' "${S}/Makefile"
}

src_install() {
	dobin grappa || die
	dosym grappa /usr/bin/invdist
	dosym grappa /usr/bin/distmat
	dodoc README
}
