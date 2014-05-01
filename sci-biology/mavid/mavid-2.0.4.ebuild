# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Multiple alignment of large DNA sequences"
HOMEPAGE="http://baboon.math.berkeley.edu/mavid/"
SRC_URI="http://bio.math.berkeley.edu/mavid/download/mavid-package-${PV}.tar.gz"

LICENSE="mavid"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND=""
RDEPEND="sci-biology/clustalw
	sci-biology/fastdnaml"

S="${WORKDIR}/mavid-package-${PV}"

src_unpack() {
	unpack ${A}
	sed -i 's/\(OPT_CPP_OPTIONS =\)/\1 ${CFLAGS} /' "${S}"/{bioc,mavid}/Makefile || die
	sed -i 's/\(CPP_OPTIONS =\) -O4/\1 ${CFLAGS} -O4/' "${S}"/utils/*/Makefile || die
	sed -i 's/$.*_DIRECTORY\///' "${S}"/mavid/mavid.pl || die
}

src_install() {
	dobin mavid/{mavid,mavid.pl}
	for i in checkfasta cut_alignment extract_seq extract_tree fasta2phylip phylip2fasta project_alignment randtree root_tree tree_dists; do
		dobin utils/$i/$i
	done
	dodoc examples/*
	newdoc mavid/README README.mavid
}
