# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 toolchain-funcs

DESCRIPTION="Computing 1-loop amplitudes at the integrand level"
HOMEPAGE="https://www.ugr.es/~pittau/CutTools/"
SRC_URI="https://www.ugr.es/~pittau/CutTools/${PN}_v${PV}.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+dummy"
DEPEND="
	sci-physics/qcdloop
	sci-physics/oneloop[dpkind,qpkind16,-qpkind,-tlevel]
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i 's/^ALL =.*$/ALL = $(CTS)/' src/makefile ||  die
	if use dummy ; then
		cp "${FILESDIR}"/mpnumdummy.f90 src/cts/mpnumdummy.f90 || die
	fi
	if use dummy ; then
		sed -i 's/CTS =/CTS = mpnumdummy.o/' src/makefile || die
	fi
}

src_compile() {
	emake -j1 FFLAGS="${FFLAGS} -I${ESYSROOT}/usr/include -fPIC -std=legacy"
	tc-export AR CXX
	cd includects || die
	${AR} -x libcts.a || die
	${CXX} ${CXXFLAGS} -shared *.o -o lib${PN}.so || die
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
