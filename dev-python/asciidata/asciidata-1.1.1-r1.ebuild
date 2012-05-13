# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST=setup.py
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-*"

inherit distutils

DESCRIPTION="Python module to handle ASCII tables"
HOMEPAGE="http://www.stecf.org/software/astroasciidata/index.html"
SRC_URI="http://www.stecf.org/software/PYTHONtools/astro${PN}/source/${P}.tar.gz"

IUSE="doc test"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"

RDEPEND="dev-python/numpy
	dev-python/pyfits"
DEPEND="doc? ( dev-tex/latex2html )
	test? ( ${RDEPEND} )"

src_compile() {
	distutils_src_compile
	if use doc; then
		pushd doc &> /dev/null
		latex2html ${PN}.tex
		popd &> /dev/null
	fi
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml -r doc/${PN}/
	fi
}
