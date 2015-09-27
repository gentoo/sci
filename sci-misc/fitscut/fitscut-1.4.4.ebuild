# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="Extract cutouts from FITS image files"
HOMEPAGE="http://acs.pha.jhu.edu/general/software/fitscut/"
SRC_URI="${HOMEPAGE}/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=sci-libs/cfitsio-3:0=
	sci-astronomy/wcstools:0=
	media-libs/libpng:0=
	virtual/jpeg:0="
DEPEND="${RDEPEND}"

src_prepare() {
	# gentoo wcs is called wcstools to avoid conflict with wcslib
	sed -i \
		-e 's/libwcs/wcs/g' \
		wcs*.c fitscut.c || die
	# cfitsio/fitsio.h might conflict with host on prefix
	sed -i \
		-e 's/LIB(wcs,/LIB(wcstools,/' \
		-e 's/-lwcs/-lwcstools/' \
		-e '/cfitsio\/fitsio.h/d' \
		configure.in || die
	autotools-utils_src_prepare
}
