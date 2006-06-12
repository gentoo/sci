# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Multi-dimensional array object and processing for Python."
SRC_URI="mirror://sourceforge/numpy/${P}.tar.gz"
HOMEPAGE="http://www.scipy.org/numpy"
IUSE="lapack"

# force atlas, while eselect blas/lapack gets more usable
DEPEND=">=dev-lang/python-2.3
	!dev-python/f2py
	lapack? ( sci-libs/blas-atlas sci-libs/lapack-atlas )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# sed to patch ATLAS libraries names (gentoo specific)
	sed -i \
		-e "s:f77blas: blas:g" \
		-e "s:'f77blas':'blas':g" \
		numpy/distutils/system_info.py

	#
	export MKL=None
	export BLAS=None
	export LAPACK=None
	export PTATLAS=None

	if use lapack; then
		echo "[atlas]"  > site.cfg
		echo "include_dirs = /usr/include/atlas" >> site.cfg
		echo "atlas_libs = lapack, blas, cblas, atlas" >> site.cfg
		echo -n "library_dirs = /usr/$(get_libdir)/lapack:" >> site.cfg
		if [ -d "/usr/$(get_libdir)/blas/threaded-atlas" ]; then
			echo "/usr/$(get_libdir)/blas/threaded-atlas" >> site.cfg
		else
			echo "/usr/$(get_libdir)/blas/atlas" >> site.cfg
		fi
	else
		export ATLAS=None
	fi
}

src_install() {
	distutils_src_install
	dodoc numpy/doc/*
}
