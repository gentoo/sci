# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="All-electron full-potential linearised augmented-plane wave (FP-LAPW) code with advanced features."
HOMEPAGE="http://elk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-debug lapack libxc mpi openmp perl test"

RDEPEND="lapack? ( virtual/blas
		virtual/lapack )
	libxc? ( =sci-libs/libxc-1*[fortran] )
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	perl? ( dev-lang/perl )
	dev-util/pkgconfig"

DOCS=( README  )

FORTRAN_STANDARD=90

pkg_setup() {
	# fortran-2.eclass does not handle mpi wrappers
	if use mpi; then
		export FC="mpif90"
		export F77="mpif77"
		export CC="mpicc"
		export CXX="mpic++"
	else
		tc-export FC F77 CC CXX
	fi

	if use openmp; then
		FORTRAN_NEED_OPENMP=1
	fi

	fortran-2_pkg_setup

	if use openmp; then
		export FC="${FC} -fopenmp"
		export F77="${F77} -fopenmp"
		export CC="${CC} -fopenmp"
		export CXX="${CXX} -fopenmp"
	fi
}

src_prepare() {
	if use libxc; then
		sed -i -e's/^\(SRC_libxc =\)/#\1/' "${S}/src/Makefile"
	fi
	if use mpi; then
		sed -i -e's/^\(SRC_mpi =\)/#\1/' "${S}/src/Makefile"
	fi
}

src_configure() {
	FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O3 -funroll-loops -ffast-math}}"
	FCFLAGS="${FCFLAGS} -I/usr/include -I/usr/$(get_libdir)/finclude"
	CFLAGS="${CFLAGS:- -O3 -funroll-loops -ffast-math}"
	CXXFLAGS="${CXXFLAGS:- ${CFLAGS}}"
	export FCFLAGS CFLAGS CXXFLAGS
	echo "MAKE = make" > make.inc
	echo "F90 = $FC" >> make.inc
	echo "F90_OPTS = $FCFLAGS" >> make.inc
	echo "F77 = $FC" >> make.inc
	echo "F77_OPTS = $FCFLAGS" >> make.inc
	echo "CC = ${CC}" >> make.inc
	echo "CXX = ${CXX}" >> make.inc
	echo "CFLAGS = ${CFLAGS}" >> make.inc
	echo "CXXFLAGS = ${CXXFLAGS}" >> make.inc
	echo "LD = $(tc-getLD)" >> make.inc
	echo "AR = ar" >> make.inc
	echo "LIB_SYS = " >> make.inc
	if use lapack; then
		echo "LIB_LPK = $(pkg-config --libs lapack)" >> make.inc
	else
		echo "LIB_LPK = lapack.a blas.a" >> make.inc
	fi
	echo "LIB_FFT = fftlib.a" >> make.inc
	if use libxc; then
		echo "LIB_XC = -L/usr/$(get_libdir) -lxc" >> make.inc
		echo "SRC_libxc = libxc_funcs.f90 libxc.f90 libxcifc.f90" >>make.inc
	fi
}

src_compile() {
	emake -j1 || die "make failed"
}

src_test() {
	emake test
}

src_install() {
	dobin src/elk src/protex src/eos/eos src/spacegroup/spacegroup
	dobin utilities/elk-bands
	use perl && dobin utilities/xps_exc.pl utilities/se.pl
	dodoc README
	for doc in docs/*; do
		dodoc $doc
	done
	insinto /usr/share/${P}
	doins -r species
	doins -r utilities
	doins -r examples
	doins -r tests
}
