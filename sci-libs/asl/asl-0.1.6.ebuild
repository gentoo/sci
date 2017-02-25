# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=ASL

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/AvtechScientific/${MY_PN}.git"
else
	SRC_URI="https://github.com/AvtechScientific/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

CMAKE_MIN_VERSION=3.0.2
CMAKE_MAKEFILE_GENERATOR="${CMAKE_MAKEFILE_GENERATOR:-ninja}"

inherit cmake-utils

DESCRIPTION="Advanced Simulation Library - multiphysics simulation software package"
HOMEPAGE="http://asl.org.il/"
LICENSE="AGPL-3"
SLOT="0"
IUSE="doc examples matlab"

RDEPEND="
	>=dev-libs/boost-1.55:=
	>=sci-libs/vtk-6.1
	>=virtual/opencl-0-r2
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	matlab? ( >=sci-libs/matio-1.5.2 )
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_SKIP_RPATH=yes
		$(cmake-utils_use_with doc API_DOC)
		$(cmake-utils_use_with examples)
		$(cmake-utils_use_with matlab)
	)
	cmake-utils_src_configure
}
