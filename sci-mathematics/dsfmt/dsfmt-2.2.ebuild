# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MYP=dSFMT-src-${PV}

DESCRIPTION="Double precision SIMD-oriented Fast Mersenne Twister library"
HOMEPAGE="http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT"
SRC_URI="${HOMEPAGE}/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/${MYP}"

src_test() {
	emake std-check
}

src_install() {
	doheader dSFMT.c d*.h
	dodoc README*txt CHANGE*
}
