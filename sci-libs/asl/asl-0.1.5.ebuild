# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CMAKE_MIN_VERSION=3.0.2
CMAKE_MAKEFILE_GENERATOR="${CMAKE_MAKEFILE_GENERATOR:-ninja}"

inherit cmake-utils

MY_PN=ASL

DESCRIPTION="Advanced Simulation Library - multiphysics simulation software package"
HOMEPAGE="http://asl.org.il/"
SRC_URI="https://github.com/AvtechScientific/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples matio"

RDEPEND="
	>=dev-libs/boost-1.55:=
	>=sci-libs/vtk-6.1
	>=virtual/opencl-0-r2
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	matio? ( >=sci-libs/matio-1.5.2 )
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_SKIP_RPATH=yes
		$(cmake-utils_use_with doc API_DOC)
		$(cmake-utils_use_with examples)
		$(cmake-utils_use_with matio)
	)
	cmake-utils_src_configure
}
