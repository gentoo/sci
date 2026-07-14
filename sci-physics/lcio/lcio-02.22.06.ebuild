# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )
CMAKE_MAKEFILE_GENERATOR="emake"

MY_PV=$(ver_rs 1- '-')
MY_P="LCIO-${MY_PV}"

inherit fortran-2 python-single-r1 cmake

DESCRIPTION="Linear Collider I/O "
HOMEPAGE="https://github.com/iLCSoft/LCIO"
SRC_URI="https://github.com/iLCSoft/LCIO/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

IUSE="root"
DEPEND="
	sci-physics/root:=[${PYTHON_SINGLE_USEDEP}]
	${PYTHON_DEPS}
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_ROOTDICT=$(usex root ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
