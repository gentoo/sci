# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib git-r3

DESCRIPTION="High Performance Visualizations for ArrayFire"
HOMEPAGE="http://www.arrayfire.com/"
EGIT_REPO_URI="https://github.com/arrayfire/${PN}.git git://github.com/arrayfire/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="examples"

RDEPEND="
	media-libs/glew:=
	>=media-libs/glfw-3.1.1
	media-libs/freetype:2
	media-libs/fontconfig:1.0
	media-libs/glbinding
	>=media-libs/glm-0.9.7.1
	virtual/opengl
	"
DEPEND="${RDEPEND}"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) -lt 4 ]] || ( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) ; then
			die "Compilation with gcc older than 4.7 is not supported."
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
	   -DBUILD_EXAMPLES="$(examples EXAMPLES)"
	   -DUSE_SYSTEM_GLBINDING=ON
	   -DUSE_SYSTEM_GLM=ON
	   -DUSE_SYSTEM_FREETYPE=ON
	   -DFG_INSTALL_CMAKE_DIR=/usr/$(get_libdir)/cmake/Forge
	)
	cmake-utils_src_configure
}
