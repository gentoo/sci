# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=ASL
CMAKE_MIN_VERSION=3.0.2
CMAKE_MAKEFILE_GENERATOR="${CMAKE_MAKEFILE_GENERATOR:-ninja}"

inherit cmake-utils

DESCRIPTION="Hardware accelerated multiphysics simulation platform"
HOMEPAGE="http://asl.org.il/"
SRC_URI="https://github.com/AvtechScientific/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
IUSE="doc examples matlab"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/boost-1.53:=
	>=sci-libs/vtk-6.1
	>=virtual/opencl-0-r2
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	matlab? ( >=sci-libs/matio-1.5.2 )
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_SKIP_RPATH=yes
		-DWITH_API_DOC="$(usex doc)"
		-DWITH_EXAMPLES="$(usex examples)"
		-DWITH_MATIO="$(usex matlab)"
	)
	cmake-utils_src_configure
}
