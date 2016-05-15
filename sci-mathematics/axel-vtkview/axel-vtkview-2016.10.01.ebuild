# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils eutils

DESCRIPTION="Axel is an algebraic geometric modeling platform"
HOMEPAGE="http://dtk.inria.fr/axel/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_URI="https://timeraider4u.github.io/myoverlay/files/${P}.tar.gz"

RDEPEND="~sci-libs/dtk-${PV}
	~sci-mathematics/axel-${PV}
	>=sci-libs/vtk-6.0.0[qt5]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PV}/CMakeLists.txt.patch"
	epatch "${FILESDIR}/${PV}/axlVtkView-CMakeLists.txt.patch"
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DAXL=ON
		-DAXEL_USED=ON
		-DDTK_USED=ON
		-DBUILD_FOR_RELEASE=ON
		-Daxel-sdk_VERSION_MAJOR=2
		-Daxel-sdk_VERSION_MINOR=4
		-Daxel-sdk_VERSION_PATCH=0
		-DVTK_QT_VERSION:STRING=5
		-DVTKVIEW_USED=ON
	)
	cmake-utils_src_configure
}
