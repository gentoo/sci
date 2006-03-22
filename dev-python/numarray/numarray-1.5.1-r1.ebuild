# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Large array processing extension module for Python"
SRC_URI="mirror://sourceforge/numpy/${P}.tar.gz"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/numarray"
# force blas-atlas because we don't have a virtual/cblas
DEPEND=">=dev-lang/python-2.3
	lapack? ( sci-libs/blas-atlas )
	lapack? ( virtual/lapack )"
IUSE="lapack"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

src_unpack() {
	unpack ${A}; 
	cd ${S}
	if use lapack; then
		local myblas="/usr/$(get_libdir)/blas/atlas"
		[ -d "/usr/$(get_libdir)/blas/threaded-atlas" ] && \
			myblas=${myblas/threaded-/}
		sed -i cfg_packages.py \
			-e 's:/usr/local/lib/atlas:${myblas}:g' \
			-e 's:/usr/local/include/atlas:/usr/include/atlas:g' \
			-e 's:f77blas:blas:g'
	fi
}

src_compile() {
	export USE_LAPACK=1
	distutils_src_compile
}

src_install() {
	distutils_src_install
	dodoc Doc/*.txt LICENSE.txt
	cp -r Doc/*.py Doc/manual Doc/release_notes \
		Examples ${D}/usr/share/doc/${PF}
}
