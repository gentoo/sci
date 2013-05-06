# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 multilib

DESCRIPTION="Sparse linear algebra extension for Python"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://pysparse.sourceforge.net/"

IUSE="doc examples"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

RDEPEND="
	dev-python/numpy
	sci-libs/superlu
	<=sci-libs/umfpack-5.4.0"
DEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-setup.patch
	"${FILESDIR}"/${P}-superlu3.patch
	)

pc_libdir() {
	$(tc-getPKG_CONFIG) --libs-only-L $@ | \
	sed -e 's/^-L//' -e 's/[ ]*-L/:/g'
}

python_prepare_all() {
	sed \
		-e "/libraries_list/s:'lapack', 'blas':$(pc_libs blas lapack):g" \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	for t in Test/test{Umfpack,Superlu}.py; do
		${PYTHON} ${t} || die
	done
}

python_install_all() {
	distutils-r1_python_install

	use doc && dodoc Doc/*.pdf

	if use examples; then
		insinto /usr/share/${PN}/
		doins -r Examples
	fi
}
