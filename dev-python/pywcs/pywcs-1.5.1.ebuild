# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
NEED_PYTHON=2.4
inherit distutils

WCS_V=4.3.3
MYP="${P}-${WCS_V}"

DESCRIPTION="Python routines for handling the FITS World Coordinate System"
HOMEPAGE="https://www.stsci.edu/trac/ssb/astrolib/"
SRC_URI="http://stsdas.stsci.edu/astrolib/${MYP}.tar.gz"

DEPEND="dev-python/pyfits"
# FIX: remove shipped wcslib to use system one
RDEPEND="${DEPEND}"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="AURA"

S="${WORKDIR}/${MYP}"

src_test() {
	# FIX: does not work, needs fits files
	PYTHONPATH=$(dir -d build/lib*) "${python}" test/test.py || die
}
