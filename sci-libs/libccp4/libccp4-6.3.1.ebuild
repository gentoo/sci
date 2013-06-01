# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

FORTRAN_NEEDED=fortran
AUTOTOOLS_AUTORECONF=true

inherit autotools-utils fortran-2

DESCRIPTION="CCP4 lib"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3 LGPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+fortran static-libs"

RDEPEND="sci-libs/mmdb"
DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=( "${FILESDIR}"/${P}-pc.patch )

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_configure() {
	local myeconfargs=( $(use_enable fortran) )
	autotools-utils_src_configure
}
