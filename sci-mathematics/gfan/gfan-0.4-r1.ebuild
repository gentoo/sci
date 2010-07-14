# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="Gfan computes Groebner fans and tropical varities"
HOMEPAGE="http://www.math.tu-berlin.de/~jensen/software/gfan/gfan.html"
SRC_URI="http://www.math.tu-berlin.de/~jensen/software/gfan/${PN}${PV}plus.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-libs/gmp[-nocxx]
	sci-libs/cddlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}plus/"

src_prepare () {
	sed -i -e "s/-O2/${CXXFLAGS}/" \
		-e "/GPROFFLAG =/d" \
		-e "s/g++/$(tc-getCXX)/" \
		-e "s/\$(CCLINKER)/& \$(LDFLAGS)/" Makefile || die

	# http://trac.sagemath.org/sage_trac/ticket/8770, the second patch
	# is a compiler bug and not needed
	epatch "${FILESDIR}"/${P}-gcc45.patch

	# Delivered by upstream, will be applied in next release
	epatch "${FILESDIR}"/${P}-fix-polynomial.patch
}

src_install() {
	emake PREFIX="${ED}/usr" install || die "emake install failed"
}
