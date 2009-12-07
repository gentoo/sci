# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="gfan computes Groebner fans and tropical varities"
HOMEPAGE="http://www.math.tu-berlin.de/~jensen/software/gfan/gfan.html"
SRC_URI="http://www.math.tu-berlin.de/~jensen/software/gfan/gfan0.4plus.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND="dev-libs/gmp[-nocxx]
		sci-libs/cddlib"

IUSE=""

RDEPEND="${DEPEND}"

S="${WORKDIR}/gfan0.4plus/"

src_prepare () {
	sed -i "s/-O2/${CXXFLAGS}/" Makefile
}

src_install() {
	dobin gfan || die "emake install failed"
}
