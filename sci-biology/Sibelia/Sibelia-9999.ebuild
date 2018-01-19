# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3

DESCRIPTION="Draw synteny plots using circos"
HOMEPAGE="http://bioinf.spbau.ru/en/sibelia"
EGIT_REPO_URI="https://github.com/bioinf/Sibelia.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-lang/perl
	dev-libs/boost:0
	dev-cpp/tclap
	>=dev-libs/libdivsufsort-2.0.1
	sci-biology/seqan:*
	sci-biology/lagan
	>=sci-biology/SnpEff-3.3"
# https://github.com/bioinf/Sibelia/issues/181
# it contains bundled copies of all the above
# we would need to create also a Gentoo package for D3.js
#   (BSD License) http://d3js.org
# it links using bundled libdivsufsort-2.0.1/lib/libdivsufsort.a
# it install stuff into /usr/lib/Sibelia/{lagan,snpEff}/
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${P}"/src
