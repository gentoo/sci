# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} )

inherit eutils distutils-r1

DESCRIPTION="Python interface generator for Fortran based codes"
HOMEPAGE="http://hifweb.lbl.gov/Forthon"
SRC_URI="http://hifweb.lbl.gov/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

python_prepare_all() {
	sed -i -e "/data_files/ s/'License.txt',//" setup.py || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	dohtml docs/index.html
	if use examples ; then
		docinto /usr/share/doc/${PF}
		dodoc -r {example,simpleexample}
	fi
	distutils-r1_python_install_all
}
