# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Automated editor of protein-coding sequences"
HOMEPAGE="http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0058387"
SRC_URI="http://www.currielab.wisc.edu/files/ORFcor.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/perl
	sci-biology/muscle
	dev-perl/Parallel-ForkManager"
	# >=sci-biology/hmmer-3.0
RDEPEND="${DEPEND}"

S="${WORKDIR}"/ORFcor

src_install(){
	dobin *.pl
	dodoc README
	insinto /usr/share/${PN}
	doins 31_HMM*
	insinto /usr/share/${PN}/test_data
	doins test_data/*
}
