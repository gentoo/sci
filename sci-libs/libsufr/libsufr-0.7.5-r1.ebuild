# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=Release
inherit cmake fortran-2
CMAKE_MAKEFILE_GENERATOR="emake"

DESCRIPTION="LIBrary of Some Useful Fortran Routines"
HOMEPAGE="http://libsufr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="virtual/fortran"
RDEPEND="${DEPEND}"

DOCS=( "CHANGELOG" "README" "VERSION" )

src_unpack() {
	default

	gunzip -r "${S}"/man || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCREATE_SHAREDLIB=ON
		-DCREATE_STATICLIB=$(usex static-libs)
	)
	cmake_src_configure
}
