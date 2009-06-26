# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python module to handle ASCII tables"
SRC_URI="http://www.stecf.org/software/PYTHONtools/astro${PN}/source/${P}.tar.gz
	doc? ( http://www.stecf.org/software/PYTHONtools/astro${PN}/manual/${PN}_${PV}.tar.gz )"
HOMEPAGE="http://www.stecf.org/software/astroasciidata/index.html"

RDEPEND="dev-python/numpy"
DEPEND="test? ( dev-python/numpy )"
IUSE="doc"
SLOT="0"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"

src_test() {
	PYTHONPATH=build/lib ${python} setup.py test || die "tests failed"
}

src_install() {
	distutils_src_install
	use doc && dohtml "${WORKDIR}"/asciidata/*
}
