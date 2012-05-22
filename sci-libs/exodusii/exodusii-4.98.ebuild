# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils eutils

DESCRIPTION="Model developed to store and retrieve transient data for finite element analyses"
HOMEPAGE="http://sourceforge.net/projects/exodusii/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs test"

DEPEND=">=sci-libs/netcdf-3.6.0"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-find-netcdf.patch
}

pkg_setup() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use !static-libs BUILD_SHARED_LIBS)
		$(cmake-utils_use test BUILD_TESTING)"
}
