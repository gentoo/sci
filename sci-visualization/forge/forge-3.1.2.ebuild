# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="High Performance Visualizations for ArrayFire"
HOMEPAGE="http://www.arrayfire.com/"
SRC_URI="https://github.com/arrayfire/${PN}/archive/af${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"
IUSE="examples"

RDEPEND="
	media-libs/glew:=
	>=media-libs/glfw-3.1.1
	media-libs/freetype:2
	media-libs/fontconfig:1.0
	>=media-libs/glm-0.9.7.1
	virtual/opengl
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-af${PV}"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) -lt 4 ]] || ( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) ; then
			die "Compilation with gcc older than 4.7 is not supported."
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
	   $(cmake-utils_use_build examples EXAMPLES)
	   -DUSE_SYSTEM_GLM=ON
	   -DUSE_SYSTEM_FREETYPE=ON
	)
	cmake-utils_src_configure
}
