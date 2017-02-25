# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python interface to NCSA HDF4 library"
HOMEPAGE="http://pysclint.sourceforge.net/pycdf/ http://pypi.python.org/pypi/pyhdf"
SRC_URI="mirror://sourceforge/pysclint/${PN}/${PV}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples szip"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/hdf[szip=]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_compile() {
	use szip || export NOSZIP=1
	distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all

	dohtml doc/*.html
	dodoc CHANGES doc/*.txt

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
