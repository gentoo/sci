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
#keyworded to x86 only because of numpy
#could use any lapack, but it seems that lapack-atlas provides non-f2c clapack routines
RDEPEND=">=dev-lang/python-2.3.3
	>=dev-python/numpy-0.9.5
	virtual/blas
	sci-libs/lapack-atlas
	fftw? ( =sci-libs/fftw-2.1* )"

# install doc claims fftw-2 is faster for complex ffts.
# install doc claims gcc-4 not fully tested
# wxwindows seems to have disapeared.
# f2py seems to be in numpy.
# 
FORTRAN="g77"

DEPEND="${RDEPEND}
    app-admin/eselect
	=sys-devel/gcc-3*"

pkg_setup() {	
	if [ -z "$(/usr/bin/eselect lapack show | grep ATLAS)" ]; then
		eerror "You need to set lapack-atlas to use this version of scipy"
		einfo "Please run:"
		einfo "\teselect lapack set ATLAS"
		einfo "or, if you have the threaded version:"
		einfo "\teselect lapack set threaded-ATLAS"		
		einfo "And re-emerge scipy"
		die "setup failed"
	fi
}

src_test() {
	einfo "Testing installation ..."
	python -c "import scipy; scipy.test(level=1)" || \
		die "Unit tests failed!"
}

src_install() {
	distutils_src_install
	dodoc `ls *.txt`
}
