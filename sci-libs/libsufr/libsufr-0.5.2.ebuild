# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils fortran-2

DESCRIPTION="LIBrary of Some Useful Fortran Routines"
HOMEPAGE="http://libsufr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="virtual/fortran"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use static-libs CREATE_STATICLIB)
	)
	cmake-utils_src_configure
}

DOCS="CHANGELOG README VERSION"
