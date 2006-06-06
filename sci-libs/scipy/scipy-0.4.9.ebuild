# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils flag-o-matic fortran

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
DESCRIPTION="Open source scientific tools for Python"
HOMEPAGE="http://www.scipy.org/"
LICENSE="BSD"

SLOT="0"
IUSE="fftw umfpack"
KEYWORDS="~amd64 ~x86"

# did not use virtual/blas and virtual/lapack
# because doc says scipy needs to compile all libraries with the same compiler
DEPEND=">=dev-lang/python-2.3.3
	>=dev-python/numpy-0.9.8
	sci-libs/blas-atlas
	sci-libs/blas-config
	sci-libs/lapack-config
	sci-libs/lapack-atlas
	fftw? ( =sci-libs/fftw-2.1* )
	umfpack? ( sci-libs/umfpack )"

# install doc claims fftw-2 is faster for complex ffts.
# install doc claims gcc-4 not fully tested and blas-atlas is compiled
# with g77 only, so force use of g77 here as well.
# wxwindows seems to have disapeared : ?
# f2py seems to be in numpy.

FORTRAN="g77 gfortran"

pkg_setup() {
	if built_with_use sci-libs/lapack-atlas ifc; then
		echo
		ewarn  "${PN} needs consistency among Fortran compilers."
		eerror "lapack-atlas was compiled with IFC, whereas"
		eerror "blas-atlas and scipy use the GNU compiler."
		eerror "please re-emerge lapack-atlas with 'USE=\"-ifc\"'."
		echo
		die "Inconsistent Fortran compilers"
	fi

	echo
	einfo "Checking active BLAS implementations for ATLAS."
	blas-config -p
	if ! blas-config -p | grep "F77 BLAS:" | grep -q ATLAS; then
		eerror "Your F77 BLAS profile is not set to the ATLAS implementation,"
		eerror "which is required by ${PN} to compile and run properly."
		eerror "Use: 'blas-config -f ATLAS' to activate ATLAS."
		echo
		bad_profile=1
	fi
	if ! blas-config -p | grep "C BLAS:" | grep -q ATLAS; then
		eerror "Your C BLAS profile is not set to the ATLAS implementation,"
		eerror "Which is required by ${PN} to compile and run properly."
		eerror "Use: 'blas-config -c ATLAS' to activate ATLAS."
		echo
		bad_profile=1
	fi
	einfo "Checking active LAPACK implementation for ATLAS."
	lapack-config -p
	if ! lapack-config -p | grep "F77 LAPACK:" | grep -q ATLAS; then
		eerror "Your F77 LAPACK profile is not set to the ATLAS implementation,"
		eerror "which is required by ${PN} to compile and run properly."
		eerror "Use: 'lapack-config ATLAS' to activate ATLAS."
		bad_profile=1
	fi
	if ! [ -z ${bad_profile} ]; then
		die "Active BLAS/LAPACK implementations are not ATLAS."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	echo "[atlas]"  > site.cfg
	echo "include_dirs = /usr/include/atlas" >> site.cfg
	echo -n "library_dirs = /usr/$(get_libdir)/lapack:/usr/$(get_libdir):" \
			>> site.cfg
	if [ -d "/usr/$(get_libdir)/blas/threaded-atlas" ]; then
		echo "/usr/$(get_libdir)/blas/threaded-atlas" >> site.cfg
		echo "atlas_libs = lapack, blas, cblas, atlas, pthread" >> site.cfg
	else
		echo "/usr/$(get_libdir)/blas/atlas" >> site.cfg
		echo "atlas_libs = lapack, blas, cblas, atlas" >> site.cfg
	fi

	export FFTW3=None
	if use fftw; then
		echo "[fftw] " >> site.cfg
		echo "fftw_libs = rfftw, fftw" >> site.cfg
		echo "fftw_opt_libs = rfftw_threads, fftw_threads" >> site.cfg
	else
		export FFTW=None
	fi

	if use umfpack; then
		echo "[umfpack] " >> site.cfg
		echo "umfpack_libs = umfpack" >> site.cfg
	else
		export UMFPACK=None
	fi

	# forcing fpic for now, avoiding it would need a lot of work
	if use amd64; then
		append-flags -fPIC
		FFLAGS="${FFLAGS} -fPIC"
	fi
}

src_install() {
	distutils_src_install
	dodoc *.txt
}
