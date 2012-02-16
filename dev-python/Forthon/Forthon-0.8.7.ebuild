# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Python interface generator for Fortran based codes"
HOMEPAGE="http://hifweb.lbl.gov/Forthon http://pypi.python.org/pypi/Forthon"
SRC_URI="http://hifweb.lbl.gov/${PN}/${P}.tgz"

LICENSE="Forthon"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

src_prepare() {
	sed -i -e "s/'Notice',//" setup.py || die
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	dohtml docs/index.html
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r {example,example2,simpleexample}
	fi
}
