# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"

inherit fortran-2 cmake

MY_P=COLLIER-${PV}

DESCRIPTION="A Complex One-Loop LIbrary with Extended Regularizations"
HOMEPAGE="https://collier.hepforge.org/index.html"
SRC_URI="https://collier.hepforge.org/downloads/?f=${P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="static-libs"
BDEPEND="
	virtual/fortran
"
PATCHES=(
    "${FILESDIR}/${PN}-1.2.7-mod.patch"
)

src_configure() {
	local mycmakeargs=(
		-Dstatic=$(usex static-libs ON OFF)
		-DLIB_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DSYSCONFIG_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)/cmake/collier
	)
	cmake_src_configure
}
