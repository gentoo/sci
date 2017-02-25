# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Cross-platform C++ binding for the OpenGL API"
HOMEPAGE="https://github.com/cginternals/glbinding"
SRC_URI="https://github.com/cginternals/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=media-libs/glfw-3.1.1
	"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.2.2
	"

PATCHES=(
	"${FILESDIR}/${P}"-CMakeLists.patch
)

src_configure() {
	local mycmakeargs=(
	   -DOPTION_BUILD_TESTS=OFF
	   -DOPTION_BUILD_GPU_TESTS=OFF
	   -DOPTION_BUILD_DOCS=OFF
	   -DOPTION_BUILD_EXAMPLES=OFF
	)
	cmake-utils_src_configure
}
