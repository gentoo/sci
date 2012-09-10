# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils multilib

DESCRIPTION="Model developed to store and retrieve transient data for finite element analyses"
HOMEPAGE="http://sourceforge.net/projects/exodusii/"
SRC_URI="mirror://sourceforge/${PN}/${P/ii/}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs test"

DEPEND=">=sci-libs/netcdf-3.6.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P/ii/}/${PN/ii/}

PATCHES=( "${FILESDIR}"/${P}-multilib.patch )

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DLIB_INSTALL_DIR=$(get_libdir)
		$(cmake-utils_use !static-libs BUILD_SHARED_LIBS)
		$(cmake-utils_use test BUILD_TESTING)"
	cmake-utils_src_configure
}
