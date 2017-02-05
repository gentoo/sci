# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} ) # requires python >= 3.1

inherit git-r3 eutils flag-o-matic

DESCRIPTION="K-mer Analysis Toolkit (histogram, filter, compare sets, plot)"
HOMEPAGE="https://github.com/TGAC/KAT"
EGIT_REPO_URI="https://github.com/TGAC/KAT.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_sse"

DEPEND="
	dev-lang/python:3
	>=dev-libs/boost-1.52
	dev-python/matplotlib
	dev-python/numpy
	sci-libs/scipy
	dev-python/sphinx"
RDEPEND="${DEPEND}"
# contains bundled a modified version of jellyfish-2.2.0 (libkat_jellyfish.{a,so})

src_prepare(){
	sh ./autogen.sh . || die
	local myconf=()
	myconf+=( --disable-gnuplot ) # python3 does better image rendering, no need for gnuplot
	use cpu_flags_x86_sse && myconf+=( $(use_with cpu_flags_x86_sse sse) ) # pass down to jellyfish-2.20/configure
	PYTHON_VERSION=3 econf ${myconf[@]}
	eapply_user
}
