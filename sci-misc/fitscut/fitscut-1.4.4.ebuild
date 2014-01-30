# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools

DESCRIPTION="Extract cutouts from FITS image files"
HOMEPAGE="http://acs.pha.jhu.edu/general/software/fitscut/"
SRC_URI="${HOMEPAGE}/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-libs/cfitsio-3
	sci-astronomy/wcstools
	media-libs/libpng
	virtual/jpeg"
DEPEND="${RDEPEND}"

src_prepare() {
	# gentoo wcs is called wcstools to avoid conflict with wcslib
	sed -i \
		-e 's/libwcs/wcs/g' \
		wcs*.c fitscut.c || die
	sed -i \
		-e 's/LIB(wcs,/LIB(wcstools,/' \
		-e 's/-lwcs/-lwcstools/' \
		configure.in || die
	eautoreconf
}

src_install() {
	emake DESDTIR="${D}" || die "emake install failed"
	dodoc README AUTHORS TODO NEWS ChangeLog THANKS
}
