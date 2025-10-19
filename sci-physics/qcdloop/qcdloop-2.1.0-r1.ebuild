# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake fortran-2

DESCRIPTION="An object-oriented one-loop scalar Feynman integrals framework"
HOMEPAGE="
	https://qcdloop.web.cern.ch/
	https://github.com/scarrazza/qcdloop
"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scarrazza/qcdloop"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/scarrazza/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-static.patch
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DCMAKE_INSTALL_PREFIX="${ESYSROOT}"/usr
		-DENABLE_FORTRAN_WRAPPER=ON
		-DENABLE_STATIC_LIBRARY=$(usex static-libs ON OFF)
	)
	cmake_src_configure
}
