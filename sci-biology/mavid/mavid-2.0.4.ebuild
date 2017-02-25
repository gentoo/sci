# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Multiple alignment of large DNA sequences"
HOMEPAGE="http://baboon.math.berkeley.edu/mavid/"
SRC_URI="http://bio.math.berkeley.edu/mavid/download/mavid-package-${PV}.tar.gz"

LICENSE="mavid"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="
	sci-biology/clustalw
	sci-biology/fastdnaml"

S="${WORKDIR}"/${PN}-package-${PV}

src_prepare() {
	sed \
		-e 's:OPT_CPP_OPTIONS =:OPT_CPP_OPTIONS ?=:g' \
		-e 's:DEBUG_CPP_OPTIONS =:DEBUG_CPP_OPTIONS ?=:g' \
		-i $(find -type f -name Makefile) || die
}

src_compile() {
	emake \
		CPP=$(tc-getCXX) \
		BASE_CPP_OPTIONS="${CXXFLAGS}" \
		DEBUG_CPP_OPTIONS="${CXXFLAGS}" \
		OPT_CPP_OPTIONS="${CXXFLAGS}"

}

src_install() {
	local i
	dobin mavid/{mavid,mavid.pl}
	for i in checkfasta cut_alignment extract_seq extract_tree fasta2phylip phylip2fasta project_alignment randtree root_tree tree_dists; do
		dobin utils/$i/$i
	done
	dodoc examples/*
	newdoc mavid/README README.mavid
}
