# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Find ORFs by comparing two genomic/EST sequences"
HOMEPAGE="http://genome.crg.es/software/sgp2/"
SRC_URI="ftp://genome.crg.es/pub/software/sgp2/sgp2_v1.1.May_8_2012.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	sci-biology/geneid"

S="${WORKDIR}"/"${PN}"

src_prepare() {
	# disable bundled geneid sources
	epatch "${FILESDIR}"/Makefile.patch
	# do not look for renamed geneid-sgp binary
	sed -i -e 's#geneid-sgp#geneid#g' src/sgp2.pl
}

src_install() {
	dobin bin/sgp2 bin/parseblast
	insinto /usr/share/"${PN}"
	doins -r param samples
}
