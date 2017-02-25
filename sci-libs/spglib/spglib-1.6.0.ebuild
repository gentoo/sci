# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils versionator

MY_PV=$(get_version_component_range 1-2 ${PV})

DESCRIPTION="Spglib is a C library for finding and handling crystal symmetries"
HOMEPAGE="http://spglib.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${PN}/${PN}-${MY_PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openmp"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-openmp.patch" )

src_configure() {
	local myconf=$(use_enable openmp)
	econf ${myconf}
}

src_compile() {
	default
}
