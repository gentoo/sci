# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils fortran flag-o-matic

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
DESCRIPTION="Open source scientific tools for Python"
HOMEPAGE="http://www.scipy.org/"
LICENSE="BSD"

SLOT="0"
IUSE="fftw umfpack"
KEYWORDS="~amd64 ~x86"

# doc says scipy needs to compile all libraries with the same compiler
RDEPEND=">=dev-lang/python-2.3.3
	>=dev-python/numpy-1.0_beta1
	virtual/blas
	virtual/lapack
	fftw? ( =sci-libs/fftw-2.1* )
	umfpack? ( sci-libs/umfpack )"

DEPEND="${RDEPEND}
	umfpack? ( dev-lang/swig )"

# install doc claims fftw-2 is faster for complex ffts.
# wxwindows seems to have disapeared : ?
# f2py seems to be in numpy.

FORTRAN="g77 gfortran"

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
}

src_compile() {
	# Map compilers to what scipy calls them
	local SCIPY_FC
	case "${FORTRANC}" in
		gfortran)
			SCIPY_FC="gnu95"
			;;
		g77)
			SCIPY_FC="gnu"
			;;
		g95)
			SCIPY_FC="g95"
			;;
		ifc|ifort)
			if use ia64; then
				SCIPY_FC="intele"
			else
				SCIPY_FC="intel"
			fi
			;;
		*)
			local msg="Invalid Fortran compiler \'${FORTRANC}\'"
			eerror "${msg}"
			die "${msg}"
			;;
	esac

	# http://projects.scipy.org/scipy/numpy/ticket/182
	# Can't set LDFLAGS
	unset LDFLAGS
	export F77FLAGS="${CFLAGS} -fPIC"
	distutils_src_compile \
		config_fc \
		--fcompiler=${SCIPY_FC} \
		--opt="${CFLAGS}" \
		|| die "compilation failed"
}

src_install() {
	distutils_src_install
	dodoc *.txt
}
