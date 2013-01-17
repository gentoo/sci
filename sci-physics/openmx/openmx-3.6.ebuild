# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Open source package for Material eXplorer using DFT, norm-conserving
pseudopotentials, and pseudo-atomic localized basis functions."
HOMEPAGE="http://www.openmx-square.org/"
SRC_URI="http://www.openmx-square.org/${PN}${PV}.tar.gz
		http://www.openmx-square.org/bugfixed/11Nov14/patch${PV}.1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-debug mpi openmp test"
S="${WORKDIR}/${PN}${PV}"

RDEPEND="virtual/blas
		virtual/lapack
		sci-libs/fftw:3
		mpi? ( virtual/mpi
		     sci-libs/fftw:3[mpi] )
		openmp? ( sys-devel/gcc[openmp]
		     sci-libs/fftw:3[openmp] )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"


pkg_setup() {
	if use mpi; then
		export CC="mpicc"
	else
		tc-export CC
	fi

	if use openmp; then
		export CC="${CC} -fopenmp"
	fi
}

src_prepare() {
	cd "${WORKDIR}"
	mv *.out "${PN}${PV}"/work/input_example
	mv *.[hc] "${PN}${PV}"/source
}

src_configure() {
	CFLAGS="${CFLAGS:- -O3 -funroll-loops -ffast-math}"
	local FFTW_FLAVOUR=fftw3
	if use openmp; then
	   FFTW_FLAVOUR=fftw3_omp
	else
	   export CFLAGS="${CFLAGS} -Dnoomp"
	fi
	if use mpi; then
	   FFTW_FLAVOUR=fftw3_mpi
	else
	   export CFLAGS="${CFLAGS} -Dnompi"
	fi
	CFLAGS="${CFLAGS} $(pkg-config --cflags lapack)"
	CFLAGS="${CFLAGS} $(pkg-config --cflags ${FFTW_FLAVOUR})"
	export CFLAGS

	local MX_LIB="$(pkg-config --static --libs lapack)"
	local MX_LIB="${MX_LIB} $(pkg-config --static --libs ${FFTW_FLAVOUR})"

	sed -i -e "s%^CC *=.*$%CC  = ${CC} ${CFLAGS}%" \
	    -e "s%^LIB *=.*$%LIB = ${MX_LIB}%" \
	    source/makefile
}

src_compile() {
	cd source
	emake || die "make failed"
}

src_test() {
	cd work
	../source/openmx -runtest
}

src_install() {
	insinto /usr/share/${P}
	doins -r DFT_DATA11
	cd work
	insinto /usr/share/${P}/examples
	doins -r *
	cd ../source
	dodir /usr/bin
	emake DESTDIR="${D}/usr/bin" install
	dodoc "${S}/${PN}${PV}.pdf"
	use test && dodoc "${S}"/work/runtest.result
}