# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="High Performance Visualizations for ArrayFire"
HOMEPAGE="http://www.arrayfire.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/arrayfire/forge"
else
	SRC_URI="https://github.com/arrayfire/forge/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="doc examples"

RDEPEND="
	dev-libs/boost
	media-libs/glfw
	media-libs/fontconfig:1.0
	media-libs/freeimage
	media-libs/freetype:2
	media-libs/glbinding
	media-libs/glm
	virtual/opengl
	"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen
		dev-python/breathe
		dev-python/recommonmark
		dev-python/sphinx
	)
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DFG_USE_STATIC_CPPFLAGS=OFF
		-DFG_BUILD_DOCS=$(usex doc ON OFF)
		-DFG_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DFG_WITH_FREEIMAGE=ON
		-DFG_USE_STATIC_FREEIMAGE=OFF
		-DFG_INSTALL_CMAKE_DIR=/usr/$(get_libdir)/cmake/Forge
	)
	cmake_src_configure
}
