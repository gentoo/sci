# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake fortran-2

DESCRIPTION="An object-oriented one-loop scalar Feynman integrals framework"
HOMEPAGE="https://qcdloop.web.cern.ch/"
SRC_URI="https://github.com/scarrazza/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="static-libs"

src_prepare() {
	cmake_src_prepare

	# gentoo libdir love
	sed -i \
		-e '/DESTINATION/s/lib/lib${LIB_SUFFIX}/g' \
		CMakeLists.txt || die
	sed -i \
		-e '/libdir.*/s/lib/lib${LIB_SUFFIX}/g' \
		CMakeLists.txt || die

	if use static-libs; then
		sed -i \
			-e '/qcdloop/s/SHARED/STATIC/g' \
			CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${ESYSROOT}"/usr
		-DENABLE_FORTRAN_WRAPPER=ON
	)
	cmake_src_configure
}
