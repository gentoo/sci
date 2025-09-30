# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 toolchain-funcs

MY_V="$(ver_cut 1).$(ver_cut 2)"

DESCRIPTION="Computing 1-loop amplitudes at the integrand level"
HOMEPAGE="https://www.ugr.es/~pittau/CutTools/"
SRC_URI="https://www.ugr.es/~pittau/CutTools/${PN}_v${MY_V}.tar.gz"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+dummy mpfun90"
DEPEND="
	sci-libs/mpfun90
	sci-physics/qcdloop
	sci-physics/oneloop[dpkind,qpkind16,-qpkind,-tlevel,mpfun90?]
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.9.3-unbundle.patch"
)

src_prepare() {
	default
	sed -i 's/^ALL =.*$/ALL = $(CTS)/' src/makefile || die
	if use dummy ; then
		cp "${FILESDIR}"/mpnumdummy.f90 src/cts/mpnumdummy.f90 || die
	fi
	if use dummy ; then
		sed -i 's/CTS =/CTS = mpnumdummy.o/' src/makefile || die
	fi
	if use mpfun90; then
		sed -i 's/PRECISION=.*$/PRECISION= MP/g' makefile || die
	else
		sed -i 's/PRECISION=.*$/PRECISION= QP/g' makefile || die
	fi
}

src_compile() {
	if use mpfun90; then
		emake -j1 FFLAGS="${FFLAGS} -I${ESYSROOT}/usr/include -fPIC -std=legacy" mp
	else
		emake -j1 FFLAGS="${FFLAGS} -I${ESYSROOT}/usr/include -fPIC -std=legacy" qp
	fi
	tc-export AR CXX
	cd includects || die
	${AR} -x libcts.a || die
	${CXX} ${CXXFLAGS} ${LDFLAGS} -shared *.o -Wl,-soname,libcuttools.so -lqcdloop -lmpfun90 -o lib${PN}.so || die
}

src_install() {
	cd includects || die
	dolib.so lib${PN}.so
	cd .. || die
	mv includects ${PN} || die
	rm ${PN}/*.a || die
	rm ${PN}/*.so || die
	rm ${PN}/*.o || die
	doheader -r ${PN}
}
