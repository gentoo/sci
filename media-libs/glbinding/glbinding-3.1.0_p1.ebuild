# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Cross-platform C++ binding for the OpenGL API"
HOMEPAGE="https://github.com/cginternals/glbinding"
COMMIT="55634e35bd8d8bf58cb36f6ed81af0a0f0939973"
SRC_URI="https://github.com/cginternals/glbinding/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/glfw
	media-libs/libglvnd
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-vcs/git
"

PATCHES=(
	"${FILESDIR}/${P}"-CMakeLists.patch
	"${FILESDIR}/${P}"-source_CMakeLists.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DOPTION_SELF_CONTAINED=OFF
		-DOPTION_BUILD_TESTS=OFF
		-DOPTION_BUILD_DOCS=OFF
		-DOPTION_BUILD_EXAMPLES=OFF
		-DOPTION_BUILD_WITH_BOOST_THREAD=OFF
		-DOPTION_BUILD_CHECK=OFF
		-DOPTION_BUILD_OWN_KHR_HEADERS=OFF
		-DOPTION_BUILD_WITH_LTO=OFF
	)
	cmake_src_configure
}
