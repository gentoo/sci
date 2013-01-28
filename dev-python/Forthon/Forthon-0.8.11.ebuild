# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} )

inherit distutils-r1

DESCRIPTION="Python interface generator for Fortran based codes"
HOMEPAGE="http://hifweb.lbl.gov/Forthon http://pypi.python.org/pypi/Forthon"
SRC_URI="http://hifweb.lbl.gov/${PN}/${P}.tgz"

LICENSE="LLNL-BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

python_prepare_all() {
	sed -i -e "/data_files/ s/'License.txt',//" setup.py || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	dohtml docs/index.html
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r {example,example2,simpleexample}
	fi
	distutils-r1_python_install_all
}
