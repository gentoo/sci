# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="A sample Dual Contouring implementation"
HOMEPAGE="https://github.com/simoncblyth/DualContouringSample"

EGIT_REPO_URI="https://github.com/simoncblyth/${PN}.git"
EGIT_COMMIT="d5ed08c21228575f948292422cd8542cbdce255c"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"

DEPEND="dev-util/bcm
	media-libs/glm"

PATCHES=( "${FILESDIR}"/DualContouringSample-0_glm.patch )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=include/${PN}
	)

	cmake-utils_src_configure
}
