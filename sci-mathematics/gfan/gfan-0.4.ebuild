# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="gfan computes Groebner fans and tropical varities"
HOMEPAGE="http://www.math.tu-berlin.de/~jensen/software/gfan/gfan.html"
SRC_URI="http://www.math.tu-berlin.de/~jensen/software/gfan/gfan${PV}plus.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/gmp[-nocxx]
	sci-libs/cddlib"
RDEPEND="${DEPEND}"

S=${WORKDIR}/gfan${PV}plus/

src_prepare () {
	sed -i -e "s/-O2/${CXXFLAGS}/" \
		-e "/GPROFFLAG =/d" \
		-e "s/g++/$(tc-getCXX)/" \
		-e "s/\$(CCLINKER)/& \$(LDFLAGS)/" Makefile || die

	# http://trac.sagemath.org/sage_trac/ticket/8770
	epatch "${FILESDIR}"/${P}-gcc45.patch
}

src_install() {
	dobin gfan || die
}
