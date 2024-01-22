# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=ASL
CMAKE_MAKEFILE_GENERATOR="${CMAKE_MAKEFILE_GENERATOR:-ninja}"

inherit cmake git-r3

DESCRIPTION="Hardware accelerated multiphysics simulation platform"
HOMEPAGE="http://asl.org.il/"
EGIT_REPO_URI="git://github.com/AvtechScientific/${MY_PN}.git"

LICENSE="AGPL-3"
SLOT="0"
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
