# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils versionator

MY_PV=$(get_version_component_range 1-2 ${PV})

DESCRIPTION="Spglib is a C library for finding and handling crystal symmetries"
HOMEPAGE="http://spglib.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${PN}/${PN}-${MY_PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openmp"

PATCHES=(
	"${FILESDIR}/${P}-openmp.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static \
		$(use_enable openmp)
}

src_install() {
	default
	prune_libtool_files --all
}
