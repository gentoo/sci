# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python package for displaying arrays in DS9"
SRC_URI="http://stsdas.stsci.edu/${PN}/download/${PN}_v${PV/./}.tar"
HOMEPAGE="http://stsdas.stsci.edu/numdisplay/"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="as-is"
DEPEND=">=dev-lang/python-2.3
	dev-python/numarray"
IUSE="doc"

S=${WORKDIR}/${PN}

src_install() {
	sed -i -e '$d' setup.py
	distutils_src_install
	if use doc; then
		dohtml -r doc/api/*
		dosym /usr/share/doc/${PF}/html/{private,public}
		insinto /usr/share/doc/${PF}
		doins doc/numdisplay_HOWTo.pdf
	fi
}
