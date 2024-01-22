# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=ASL
CMAKE_MAKEFILE_GENERATOR="${CMAKE_MAKEFILE_GENERATOR:-ninja}"

inherit cmake

DESCRIPTION="Hardware accelerated multiphysics simulation platform"
HOMEPAGE="http://asl.org.il/"
SRC_URI="https://github.com/AvtechScientific/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc examples matlab"

RDEPEND="
	>=dev-libs/boost-1.53:=
	>=sci-libs/vtk-6.1
	>=virtual/opencl-0-r2
"
DEPEND="${RDEPEND}
	matlab? ( >=sci-libs/matio-1.5.2 )
"
BDEPEND="doc? ( app-text/doxygen[dot] )"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	cmake_src_prepare
	# allow use of vtk 8.2
	sed -i -e 's/find_package(VTK 7.0/find_package(VTK 8.2/g' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_SKIP_RPATH=yes
		-DWITH_API_DOC="$(usex doc)"
		-DWITH_EXAMPLES="$(usex examples)"
		-DWITH_MATIO="$(usex matlab)"
	)
	cmake_src_configure
}
