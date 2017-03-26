# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Vtk plug-in for sci-mathematics/axel"
HOMEPAGE="http://dtk.inria.fr/axel/"
SRC_URI="https://timeraider4u.github.io/distfiles/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="~sci-libs/dtk-${PV}
	~sci-mathematics/axel-${PV}
	>=sci-libs/vtk-6.0.0[qt5,rendering]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}/CMakeLists.txt.patch"
	"${FILESDIR}/${PV}/axlVtkView-CMakeLists.txt.patch"
)

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
