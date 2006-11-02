# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit distutils

MY_P=${P/_beta/b}
MY_P=${MY_P/_}
DESCRIPTION="Multi-dimensional array object and processing for Python."
SRC_URI="mirror://sourceforge/numpy/${MY_P}.tar.gz"
HOMEPAGE="http://numeric.scipy.org/"
# numpy provides the latest version of dev-python/f2py
DEPEND=">=dev-lang/python-2.3
	!dev-python/f2py
	lapack? ( virtual/blas
		virtual/lapack )"
IUSE="lapack"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="BSD"
RESTRICT="test"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# sed to patch ATLAS libraries names (gentoo specific)
	sed -i \
		-e "s:f77blas:blas:g" \
		-e "s:ptblas:blas:g" \
		-e "s:ptcblas:cblas:g" \
		-e "s:lapack_atlas:lapack:g" \
		numpy/distutils/system_info.py

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
		rm -f site.cfg
		export ATLAS=None
	fi
}

src_compile() {
	# http://projects.scipy.org/scipy/numpy/ticket/182
	# Can't set LDFLAGS
	unset LDFLAGS

	distutils_src_compile
}

src_install() {
	distutils_src_install
	dodoc numpy/doc/*
}
