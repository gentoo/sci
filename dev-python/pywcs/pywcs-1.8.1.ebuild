# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit distutils eutils

WCS_V=4.4.4
MYP="${P}-${WCS_V}"

DESCRIPTION="Python routines for handling the FITS World Coordinate System"
HOMEPAGE="https://www.stsci.edu/trac/ssb/astrolib/"
SRC_URI="http://stsdas.stsci.edu/astrolib/${MYP}.tar.gz"

DEPEND="dev-python/pyfits
	>=sci-astronomy/wcslib-4.4.4"
RDEPEND="${DEPEND}"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="AURA"

S=${WORKDIR}/${MYP}

src_prepare(){
	epatch "${FILESDIR}"/${P}-wcslib.patch
}

# FIX: compiles twice due to stsci hacks

src_test() {
	# FIX: does not work, needs fits files
	PYTHONPATH=$(dir -d build/lib*) "${python}" test/test.py || die
}
