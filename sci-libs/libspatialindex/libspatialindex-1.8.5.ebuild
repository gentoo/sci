# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

MY_PN="spatialindex-src"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="General framework for developing spatial indices"
HOMEPAGE="http://libspatialindex.github.com/"
SRC_URI="http://download.osgeo.org/libspatialindex/${MY_P}.tar.bz2"

SLOT="0/4"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="debug static-libs"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-1.8.1-QA.patch )

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=( $(use_enable debug) )
	autotools-utils_src_configure
}
