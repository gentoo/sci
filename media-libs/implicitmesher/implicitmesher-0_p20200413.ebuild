# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

COMMIT="4b7a47056074"

DESCRIPTION="Real-time implicit surface polygonization"
HOMEPAGE="https://bitbucket.org/simoncblyth/implicitmesher"
SRC_URI="https://bitbucket.org/simoncblyth/implicitmesher/get/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-libs/glm"
DEPEND="${RDEPEND}"

S="${WORKDIR}/simoncblyth-${PN}-${COMMIT}"

PATCHES=( "${FILESDIR}"/implicitmesher-0_glm.patch )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=include/ImplicitMesher
	)

	cmake_src_configure
}
