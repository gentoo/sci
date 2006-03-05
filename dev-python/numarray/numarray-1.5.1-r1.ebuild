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

src_compile() {

	local myconf="--genapi"
	if use lapack; then
		sed -i cfg_packages.py \
			-e 's:/usr/local/lib/atlas:/usr/lib/blas/atlas:g' \
			-e 's:/usr/local/include/atlas:/usr/include/atlas:g' \
			-e 's:f77blas:blas:g'
		myconf="${myconf} --use_lapack"
	fi
	python setup.py build ${myconf} || die "build failed"
}

src_test() {
	einfo "Testing installation ..."
	python -c "import numarray.testall as nt; nt.test()" || \
		die "test failed!"
}

src_install() {
	distutils_src_install
	dodoc Doc/*.txt LICENSE.txt
	cp -r Doc/*.py Doc/manual Doc/release_notes Examples ${D}/usr/share/doc/${PF}
}
