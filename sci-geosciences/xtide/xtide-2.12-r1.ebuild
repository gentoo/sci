# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="XTide provides tide and current predictions in a wide variety of formats."
HOMEPAGE="http://www.flaterco.com/xtide/"
SRC_URI="ftp://ftp.flaterco.com/xtide/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="non-commercial"
DEPEND=">=x11-libs/libXaw-1.0.3
	>=x11-libs/libXpm-3.5.6
	>=media-libs/libpng-1.2.25
	>=sci-geosciences/libtcd-2.2.5-r1[non-commercial?]"
RDEPEND="${DEPEND}"

src_install() {
	dobin xtide tide xttpd
	doman *.[18]

	echo 'HFILE_PATH=/usr/share/harmonics/' > 50xtide_harm
	doenvd 50xtide_harm

	make_desktop_entry ${PN} 'Tide predition' ${PN} 'Science'
}
