# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Powerful N-dimensional array object and processing for Python."
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

	if use lapack; then
		# only modify [atlas]
		# the default [blas] and [lapack] are fine
		# for other implementations
		echo "[atlas]"  > site.cfg
		echo "include_dirs = /usr/include/atlas" >> site.cfg
		echo "atlas_libs = lapack, blas, cblas, atlas" >> site.cfg
		echo -n "library_dirs = /usr/$(get_libdir)/lapack:" >> site.cfg
		if [ -d "/usr/$(get_libdir)/blas/threaded-atlas" ]; then
			echo "/usr/$(get_libdir)/blas/threaded-atlas" >> site.cfg
		elif [ -d "/usr/$(get_libdir)/blas/atlas" ]; then
			echo "/usr/$(get_libdir)/blas/atlas" >> site.cfg
		fi
		
	else
		export ATLAS=None
		export PTATLAS=None
		export BLAS=None
		export LAPACK=None
		echo "[lapack_opt] =" >> site.cfg
	fi
}

src_install() {
	distutils_src_install
	dodoc numpy/doc/*
}
