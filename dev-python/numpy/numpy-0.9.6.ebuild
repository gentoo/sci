# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Numpy contains a powerful N-dimensional array object for Python."
SRC_URI="mirror://sourceforge/numpy/${P}.tar.gz"
HOMEPAGE="http://numeric.scipy.org/"
DEPEND=">=dev-lang/python-2.3
	lapack? ( virtual/blas )
	lapack? ( virtual/lapack )"
IUSE="lapack"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# note the default are fine to use with
	# blas/lapack reference and mkl.
	if use lapack; then
		echo "[atlas]"  > site.cfg
		echo "atlas_libs = lapack, blas, cblas, atlas" >> site.cfg
	else
		echo "[DEFAULT]" > site.cfg
		echo "library_dirs =" >> site.cfg
		echo "include_dirs =" >> site.cfg
		echo "src_dirs =" >> site.cfg
		echo "[blas_opt] =" >> site.cfg
		echo "[lapack_opt] =" >> site.cfg
	fi
}

# he test only works after install
# to be worked out.
#src_test() {
#	python -c "import numpy; numpy.test()" || \
#		die "test failed!"
#}

src_install() {
	distutils_src_install
	dodoc numpy/doc/*
}


