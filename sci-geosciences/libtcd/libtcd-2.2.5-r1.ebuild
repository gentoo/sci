# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Library for reading and writing Tide Constituent Database (TCD) files."
HOMEPAGE="http://www.flaterco.com/xtide/libtcd.html"
SRC_URI="ftp://ftp.flaterco.com/xtide/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc non-commercial"

DEPEND=">=sci-geosciences/harmonics-dwf-free-20110410-r1
	non-commercial?	( >=sci-geosciences/harmonics-dwf-free-noncomm-20110410-r1 )"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc ; then
		dohtml libtcd.html
	fi
}
