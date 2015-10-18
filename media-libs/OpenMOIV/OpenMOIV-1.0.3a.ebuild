# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Object-oriented 3D toolkit that facilitates the rendering and interaction of chemical systems"
HOMEPAGE="http://www.tecn.upf.es/openMOIV/"
SRC_URI="http://www.tecn.upf.es/openMOIV/download/1.0.3/${PN}.src.${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="media-libs/coin"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}.src.${PV/a//}"

src_prepare() {
	sed -e 's:$ENV{OIV_DIR}/include:/usr/include/coin:g' \
		-i CMakeLists.txt || die
}

src_configure() {
	mycmakeargs="${mycmakeargs} -Dshared:int=1 -Dcoin:int=1 -Dsys_fonts:int=1"
	cmake-utils_src_configure
}

src_install() {
	insinto "/usr/$(get_libdir)"
	doins "${CMAKE_BUILD_DIR}/libChemKit2.so"

	insinto "/usr/include"
	doins -r "${S}/include/ChemKit2"
}
