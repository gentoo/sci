# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python bindings for dev-libs/gmp"
HOMEPAGE="http://code.google.com/p/gmpy/"
SRC_URI="http://${PN}/googlecode.com/files/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

RDEPEND="virtual/python
	dev-libs/gmp"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_install() {
	distutils_src_install
	dohtml doc/index.html
	dodoc doc/gmpydoc.txt
}

src_test() {
	cd test
	PYTHONPATH="$(ls -d ../build/lib.*)" "${python}" gmpy_test.py
}
