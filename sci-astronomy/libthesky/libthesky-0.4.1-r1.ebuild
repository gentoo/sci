# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=Release
inherit cmake fortran-2
CMAKE_MAKEFILE_GENERATOR="emake"

DESCRIPTION="Fortran library to compute positions of celestial bodies"
HOMEPAGE="http://libthesky.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/libthesky-data-20160409.tar.bz2
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="~sci-libs/libsufr-0.7.5[static-libs?]"
RDEPEND="${DEPEND}"

src_unpack() {
	default

	gunzip -r "${S}"/man || die

	mv "${WORKDIR}"/data "${S}" || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCREATE_SHAREDLIB=ON
		-DCREATE_STATICLIB=$(usex static-libs)
	)
	cmake_src_configure
}
