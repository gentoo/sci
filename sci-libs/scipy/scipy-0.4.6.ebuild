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
# because scipy needs to compile all libraries with the same compiler
# needs more work
RDEPEND=">=dev-lang/python-2.3.3
	>=dev-python/numpy-0.9.5
	sci-libs/blas-atlas
	sci-libs/lapack-atlas
	fftw? ( =sci-libs/fftw-2.1* )"

DEPEND="${RDEPEND}
	app-admin/eselect
	=sys-devel/gcc-3*"

# install doc claims fftw-2 is faster for complex ffts.
# install doc claims gcc-4 not fully tested
# wxwindows seems to have disapeared : ?
# f2py seems to be in numpy.
#

FORTRAN="g77"

pkg_setup() {
	if [ -d "/usr/$(get_libdir)/blas/threaded-atlas" ]; then
		eselect blas set threaded-ATLAS
	else
		eselect blas set ATLAS
	fi
	eselect lapack set ATLAS
}

src_unpack() {
	unpack ${A}
    cd "${S}"
	einfo ""
	echo "[atlas]"  > site.cfg
	echo "atlas_libs = lapack, blas, cblas, atlas" >> site.cfg
	# let discover fftw by itself if installed
}

src_test() {
	python -c "import scipy; scipy.test(level=1)" || \
		die "tests failed"
}

src_install() {
	distutils_src_install
	dodoc `ls *.txt`
}
