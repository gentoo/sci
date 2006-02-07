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
KEYWORDS="~x86"
#keyworded to x86 only because of numpy

RDEPEND=">=dev-lang/python-2.3.3
	>=dev-python/numpy-0.9.2
	virtual/blas
	virtual/lapack
	fftw? ( =sci-libs/fftw-2.1* )"

# install doc claims fftw-2 is faster for complex ffts.
# install doc claims gcc-4 not fully tested
# wxwindows seems to have disapeared.
# f2py seems to be in numpy.
# 
FORTRAN="g77"

DEPEND="${RDEPEND}
	=sys-devel/gcc-3*"

src_test() {
	einfo "Testing installation ..."
	python -c "import scipy; scipy.test(level=1)" || \
		die "Unit tests failed!"
}

src_install() {
	distutils_src_install
	dodoc `ls *.txt`
}
