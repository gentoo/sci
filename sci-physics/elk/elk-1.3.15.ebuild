# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="All-electron full-potential linearised augmented-plane wave (FP-LAPW) code with advanced features."
HOMEPAGE="http://elk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-debug lapack libxc mpi openmp test"

RDEPEND="lapack? ( virtual/blas
		virtual/lapack )
	libxc? ( =sci-libs/libxc-1.0[fortran] )
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	fortran-2_pkg_setup
	if use openmp; then
		tc-has-openmp || \
		die "Please select an openmp capable compiler like gcc[openmp]"
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
	if use mpi; then
		MY_FC="mpif90"
		MY_CC="mpicc"
		MY_CXX="mpic++"
	else
		MY_FC="$(tc-getFC)"
		MY_CC="$(tc-getCC)"
		MY_CXX="$(tc-getCXX)"
	fi
	if use openmp; then
		MY_FC="${MY_FC} -fopenmp"
		MY_CC="${MY_CC} -fopenmp"
		MY_CXX="${MY_CXX} -fopenmp"
	fi
	MY_FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O3 -funroll-loops -ffast-math}}"
	MY_FCFLAGS="${MY_FCFLAGS} -I/usr/include -I/usr/$(get_libdir)/finclude"
	MY_CFLAGS="${CFLAGS:- -O3 -funroll-loops -ffast-math}"
	MY_CXXFLAGS="${CXXFLAGS:- ${CFLAGS:- -O3 -funroll-loops -ffast-math}}"
	echo "MAKE = make" > make.inc
	echo "F90 = $MY_FC" >> make.inc
	echo "F90_OPTS = $MY_FCFLAGS" >> make.inc
	echo "F77 = $MY_FC" >> make.inc
	echo "F77_OPTS = $MY_FCFLAGS" >> make.inc
	echo "CC = ${MY_CC}" >> make.inc
	echo "CXX = ${MY_CXX}" >> make.inc
	echo "CFLAGS = ${MY_CFLAGS}" >> make.inc
	echo "CXXFLAGS = ${MY_CXXFLAGS}" >> make.inc
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
	dobin src/elk src/eos/eos src/spacegroup/spacegroup utilities/elk-bands
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
