# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Library for reading and writing Tide Constituent Database (TCD) files."
HOMEPAGE="http://www.flaterco.com/xtide/libtcd.html"
SRC_URI="ftp://ftp.flaterco.com/xtide/${P}.tar.bz2"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
DEPEND=">=sci-geosciences/harmonics-dwf-free-20071228
	non-commercial?	( >=sci-geosciences/harmonics-dwf-free-noncomm-20071228 )"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc ; then
		dohtml libtcd.html
	fi
}
