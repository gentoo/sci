# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python module to handle ASCII tables"
SRC_URI="http://www.stecf.org/software/PYTHONtools/astro${PN}/source/${P}.tar.gz
	doc? ( http://www.stecf.org/software/PYTHONtools/astro${PN}/manual/${PN}_${PV}.tar.gz )"
HOMEPAGE="http://www.stecf.org/software/astroasciidata/index.html"

DEPEND="dev-python/numarray"
IUSE="doc"
SLOT="0"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"

src_install() {
	distutils_src_install
	use doc && dohtml "${WORKDIR}"/asciidata/*
}
