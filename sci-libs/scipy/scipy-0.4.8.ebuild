# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils fortran

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
DESCRIPTION="Open source scientific tools for Python"
HOMEPAGE="http://www.scipy.org/"
LICENSE="BSD"

SLOT="0"
IUSE="fftw"
KEYWORDS="~amd64 ~x86"

# did not use virtual/blas and virtual/lapack
# because doc says scipy needs to compile all libraries with the same compiler
RDEPEND=">=dev-lang/python-2.3.3
	>=dev-python/numpy-0.9.6
	sci-libs/blas-atlas
	sci-libs/lapack-atlas
	fftw? ( =sci-libs/fftw-2.1* )"

DEPEND="${RDEPEND}
	=sys-devel/gcc-3*"

# install doc claims fftw-2 is faster for complex ffts.
# install doc claims gcc-4 not fully tested and blas-atlas is compiled
# with g77 only, so force use of g77 here as well.
# wxwindows seems to have disapeared : ?
# f2py seems to be in numpy.

FORTRAN="g77"

pkg_setup() {

	# force ATLAS
	if [ -z "$(/usr/bin/eselect lapack show $(get_libdir) | grep ATLAS)"] &&
		[ -z "$(/usr/bin/eselect blas show $(get_libdir) C | grep ATLAS)" ]; then
		eerror "You need to set blas,lapack-atlas to use this version of scipy"
		einfo "Please run:"
		einfo "\teselect blas set ATLAS"
		einfo "\teselect lapack set ATLAS"
		einfo "or, if you have the threaded version:"
		einfo "\teselect blas set threaded-ATLAS"
		einfo "And re-emerge scipy"
		die "setup failed"
	fi

	if built_with_use lapack-atlas ifc; then
		ewarn  "scipy needs consistency among fortran compiler!"
		eerror "lapack-atlas was compiled with the ifc"
		eerror "whereas blas-atlas and scipy will use the GNU compiler"
		eerror "please re-emerge lapack-atlas with USE=-ifc"
		die
	fi
	
	fortran_pkg_setup
}

src_unpack() {
	unpack ${A}
    cd "${S}"

	echo "[atlas]"  > site.cfg
	echo "include_dirs = /usr/include/atlas" >> site.cfg
	echo "atlas_libs = lapack, blas, cblas, atlas" >> site.cfg
	echo -n "library_dirs = /usr/$(get_libdir)/lapack:/usr/$(get_libdir):" >> site.cfg
	if [ -d "/usr/$(get_libdir)/blas/threaded-atlas" ]; then
		echo "/usr/$(get_libdir)/blas/threaded-atlas" >> site.cfg
	else
		echo "/usr/$(get_libdir)/blas/atlas" >> site.cfg
	fi

	export FFTW3=None
	if use fftw; then
		echo "[fftw] " >> site.cfg
		echo "fftw_libs = rfftw, fftw" >> site.cfg
		echo "fftw_opt_libs = rfftw_threads, fftw_threads" >> site.cfg
	else
		export FFTW=None
	fi
}

src_install() {
	distutils_src_install
	dodoc `ls *.txt`
}
