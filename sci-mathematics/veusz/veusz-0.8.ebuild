# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Scientific plotting package with good Postscript output."
HOMEPAGE="http://home.gna.org/veusz/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

IUSE="doc fits"
SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"

DEPEND="virtual/python
	dev-python/numarray
	dev-python/PyQt
    fits? ( >=dev-python/pyfits-0.9.8 )"

src_install() {
	distutils_src_install
	if use doc; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
		docinto Documents
		dodoc Documents/Interface.txt
		dohtml -r Documents/{manual.xml,manimages}
		insinto /usr/share/doc/${PF}/Documents
		doins Documents/generate_manual.sh
	fi
}
