# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} ) # requires python >= 3.1 but more features with >=3.5
# https://github.com/Ensembl/Bio-DB-HTS/issues/30

inherit git-r3 eutils flag-o-matic autotools

DESCRIPTION="K-mer Analysis Toolkit (histogram, filter, compare sets, plot)"
HOMEPAGE="https://github.com/TGAC/KAT"
EGIT_REPO_URI="https://github.com/TGAC/KAT.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_sse doc"

DEPEND="
	>=dev-libs/boost-1.52
	dev-python/tabulate
	dev-python/matplotlib
	dev-python/numpy
	sci-libs/scipy
	doc? ( dev-python/sphinx )"
RDEPEND="${DEPEND}"
# contains bundled a *modified* version of jellyfish-2.2.0 (libkat_jellyfish.{a,so})
# contains embedded sci-biology/seqan

src_prepare(){
	default
	# autogen.sh
	test -n "$srcdir" || local srcdir=`dirname "$0"`
	test -n "$srcdir" || local srcdir=.
	eautoreconf --force --install --verbose "$srcdir"
}

src_configure(){
	local myconf=()
	myconf+=( --disable-gnuplot ) # python3 does better image rendering, no need for gnuplot
	use cpu_flags_x86_sse && myconf+=( $(use_with cpu_flags_x86_sse sse) ) # pass down to jellyfish-2.20/configure
	PYTHON_VERSION=3 econf ${myconf[@]}
}

src_compile(){
	# build_boost.sh
	cd deps/boost || die
	./bootstrap.sh --prefix=build --with-libraries=chrono,exception,program_options,timer,filesystem,system,stacktrace || die
	./b2 headers || die
	./b2 install || die
	cd ../.. || die
}
