# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mercurial cmake-utils

EHG_REPO_URI="https://bitbucket.org/simoncblyth/${PN}"
EHG_REVISION="a087394946d788bfd35a20b4b07909fa62f76a7a"

DESCRIPTION="Real-time implicit surface polygonization"
HOMEPAGE="https://bitbucket.org/simoncblyth/implicitmesher"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-libs/glm"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/implicitmesher-0_glm.patch )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=include/ImplicitMesher
	)

	cmake-utils_src_configure
}
