# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DISTUTILS_SRC_TEST="setup.py"

DESCRIPTION="Python module to handle ASCII tables"
SRC_URI="http://www.stecf.org/software/PYTHONtools/astro${PN}/source/${P}.tar.gz
	doc? ( http://www.stecf.org/software/PYTHONtools/astro${PN}/manual/${PN}_${PV}.tar.gz )"
HOMEPAGE="http://www.stecf.org/software/astroasciidata/index.html"

IUSE="doc"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"

RDEPEND="dev-python/numpy"
DEPEND="${RDEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

src_test() {
	PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" distutils_src_test
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml "${WORKDIR}"/asciidata/* || die
	fi
}
