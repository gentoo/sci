# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"

inherit distutils

DESCRIPTION="Python interface to NCSA HDF4 library."
HOMEPAGE="http://pysclint.sourceforge.net/pycdf/ http://pypi.python.org/pypi/pyhdf"
SRC_URI="mirror://sourceforge/pysclint/${PN}/${PV}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples szip"

RDEPEND="dev-python/numpy
	sci-libs/hdf[szip=]"
DEPEND="dev-python/setuptools
	${RDEPEND}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_compile () {
	use szip || export NOSZIP=1
	distutils_src_compile
}

src_install() {
	distutils_src_install

	dohtml doc/*.html
	dodoc CHANGES doc/*.txt

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
