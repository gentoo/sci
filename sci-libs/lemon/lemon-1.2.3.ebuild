# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="A C++ template STATIC library providing efficient implementations of common data structures and algorithms with combinatorial optimization tasks of graphs and networks."
HOMEPAGE="https://lemon.cs.elte.hu/trac/lemon/"
SRC_URI="http://lemon.cs.elte.hu/pub/sources/lemon-"${PV}".tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="sci-mathematics/glpk
		dev-lang/python
		doc? ( app-text/ghostscript-gpl )
		test? ( dev-util/valgrind )"
RDEPEND="${DEPEND}"

src_prepare(){
	if use test; then
		MYOPTS="--enable-valgrind"
	else
		MYOPTS=""
	fi
	econf ${MYOPTS} || die
}
