# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"

inherit fortran-2 cmake

MY_P="SM_${PV}"

DESCRIPTION="RECOLA2 Standard Model"
HOMEPAGE="https://recola.gitlab.io/recola2/index.html"
SRC_URI="https://recola.hepforge.org/downloads/?f=${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	sci-physics/collier
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DSYSCONFIG_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)/cmake
		-DCMAKE_PREFIX_PATH=/usr/$(get_libdir)
	)
	cmake_src_configure
}
