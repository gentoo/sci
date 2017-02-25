# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="SIMD-oriented Fast Mersenne Twister"
HOMEPAGE="http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/index.html"
SRC_URI="http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/VERSIONS/ARCHIVES/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2"

src_configure() {
	econf $(use_enable cpu_flags_x86_sse2 sse2)
}
