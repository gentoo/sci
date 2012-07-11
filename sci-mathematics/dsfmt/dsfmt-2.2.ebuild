
EAPI=4

MYP=dSFMT-src-${PV}

DESCRIPTION="Double precision SIMD-oriented Fast Mersenne Twister library"
HOMEPAGE="http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT"
SRC_URI="${HOMEPAGE}/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYP}"

src_test() {
	emake std-check
}

src_install() {
	insinto /usr/include
	doins dSFMT.c d*.h
	dodoc README*txt CHANGE*
}
