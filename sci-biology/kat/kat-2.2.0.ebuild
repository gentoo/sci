# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} ) # https://github.com/Ensembl/Bio-DB-HTS/issues/30

inherit python-r1 eutils flag-o-matic

DESCRIPTION="K-mer Analysis Toolkit (histogram, filter, compare sets, plot)"
HOMEPAGE="https://github.com/TGAC/KAT"
SRC_URI="https://github.com/TGAC/KAT/releases/download/Release-${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_sse"

DEPEND="dev-libs/boost:0
	dev-python/matplotlib
	sci-visualization/gnuplot"
RDEPEND="${DEPEND}"
# contains bundled modified version of jellyfish-2.2 which should install under different filenames

src_configure(){
	local myconf=()
	myconf+=( --disable-gnuplot ) # python3 does better image rendering, no need for gnuplot
	use cpu_flags_x86_sse && myconf+=( $(use_with cpu_flags_x86_sse sse) ) # pass down to jellyfish-2.20/configure
	PYTHON_VERSION=3 econf ${myconf[@]}
	eapply_user
}
