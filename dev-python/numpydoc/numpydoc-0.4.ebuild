# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Sphinx extension to support docstrings in Numpy format"
HOMEPAGE="
	http://projects.scipy.org/numpy/browser/trunk/doc/sphinxext/
	http://pypi.python.org/pypi/numpydoc/"
SRC_URI="mirror://pypi/n/${PN}/${P}.tar.gz"

LICENSE="PYTHON BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( >=dev-python/sphinx-0.5[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/sphinx-0.5[${PYTHON_USEDEP}]"

python_test() {
	${PYTHON} tests/test_docscrape.py || die
}
