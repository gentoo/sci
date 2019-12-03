# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Single File Libraries for Physically-Based Graphics"
HOMEPAGE="https://github.com/simoncblyth/yocto-gl"

EGIT_REPO_URI="https://github.com/simoncblyth/yocto-gl.git"
EGIT_COMMIT="3cfcfacafece377b4542a0ffea4030bf13ae8b3c"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"

DEPEND="dev-util/bcm"
PATCHES=( "${FILESDIR}"/yocto-gl-0_bcm-include.patch )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=include/YoctoGL
	)

	cmake-utils_src_configure
}
